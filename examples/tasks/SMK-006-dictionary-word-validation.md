---
task_id: "SMK-006"
title: "Dictionary Word Validation"
created: "2025-09-24"
priority: "High"
status: "Ready"
phase: "Sprint 1 Week 1"
dependencies: ["SMK-002", "SMK-003"]
series: "core-logic"
estimate: "8h"
assignee: ""
reviewer: ""
labels: ["core", "dictionary", "hunspell", "validation", "performance"]
complexity: "Mid"
repository: "mnemoverse/smartkeys-v2"
---

# SMK-006: Dictionary Word Validation

## 🎯 Objective

Implement word validation using Hunspell dictionaries for Russian and English with <1ms validation time so the correction engine can make informed decisions about whether words need layout correction.

## 📋 Definition of Done

- [ ] Integration with Hunspell C API for morphological word analysis
- [ ] Russian and English dictionary loading with startup time <100ms
- [ ] <1ms word validation time (95th percentile) for typical words
- [ ] Morphological analysis support for Russian word forms (case, gender, number)
- [ ] Memory efficient dictionary caching with <30MB total usage
- [ ] Fallback handling for unknown words without crashes
- [ ] Thread-safe implementation supporting concurrent validation
- [ ] Integration with Factory DI container for WordValidator protocol

## 🔧 Implementation Guide

### Prerequisites
- [ ] SMK-002 (Core Protocols) completed
- [ ] SMK-003 (Mock Framework) completed
- [ ] Understanding of C API integration in Swift
- [ ] Knowledge of Hunspell dictionary format
- [ ] Access to Russian and English dictionary files

### Step-by-Step Process

#### 1. Setup Hunspell C API Integration (Est: 2h)

**Create C API Wrapper:**
```swift
// Sources/SmartKeysCore/Validation/HunspellWrapper.swift
import Foundation

/// Low-level wrapper around Hunspell C API
public final class HunspellWrapper {
    private var hunspellHandle: OpaquePointer?
    private let language: Language

    public init(dictionaryPath: String, affixPath: String, language: Language) throws {
        self.language = language

        guard let handle = Hunspell_create(affixPath, dictionaryPath) else {
            throw ValidationError.dictionaryLoadFailed(language)
        }

        self.hunspellHandle = handle
    }

    deinit {
        if let handle = hunspellHandle {
            Hunspell_destroy(handle)
        }
    }

    /// Check if word is valid according to dictionary
    public func isValid(_ word: String) -> Bool {
        guard let handle = hunspellHandle else { return false }

        return word.withCString { cString in
            return Hunspell_spell(handle, cString) != 0
        }
    }

    /// Get suggestions for misspelled word
    public func getSuggestions(for word: String, maxCount: Int = 5) -> [String] {
        guard let handle = hunspellHandle else { return [] }

        var suggestions: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
        let count = word.withCString { cString in
            return Hunspell_suggest(handle, &suggestions, cString)
        }

        defer {
            // Free the suggestions array
            if let suggestions = suggestions {
                Hunspell_free_list(handle, &suggestions, count)
            }
        }

        guard count > 0, let suggestions = suggestions else {
            return []
        }

        var result: [String] = []
        for i in 0..<min(count, Int32(maxCount)) {
            if let suggestion = suggestions[Int(i)] {
                result.append(String(cString: suggestion))
            }
        }

        return result
    }

    /// Analyze word morphology (for Russian)
    public func analyze(_ word: String) -> [String] {
        guard let handle = hunspellHandle else { return [] }

        var analyses: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
        let count = word.withCString { cString in
            return Hunspell_analyze(handle, &analyses, cString)
        }

        defer {
            if let analyses = analyses {
                Hunspell_free_list(handle, &analyses, count)
            }
        }

        guard count > 0, let analyses = analyses else {
            return []
        }

        var result: [String] = []
        for i in 0..<count {
            if let analysis = analyses[Int(i)] {
                result.append(String(cString: analysis))
            }
        }

        return result
    }
}

/// Errors related to dictionary validation
public enum ValidationError: Error {
    case dictionaryLoadFailed(Language)
    case dictionaryNotFound(Language)
    case invalidWord
    case hunspellError(String)
}
```

#### 2. Create Dictionary Manager (Est: 2h)

**Dictionary Manager:**
```swift
// Sources/SmartKeysCore/Validation/DictionaryManager.swift
import Foundation
import Logging

/// Manages multiple language dictionaries with efficient loading and caching
@available(macOS 13.0, *)
public actor DictionaryManager {
    private let logger: Logger
    private var dictionaries: [Language: HunspellWrapper] = [:]
    private var loadingTasks: [Language: Task<HunspellWrapper, Error>] = [:]

    // Performance tracking
    private var loadTimes: [Language: TimeInterval] = [:]

    public init(logger: Logger = Logger(label: "DictionaryManager")) {
        self.logger = logger
    }

    /// Load dictionary for specified language
    public func loadDictionary(for language: Language) async throws -> HunspellWrapper {
        // Return existing dictionary if already loaded
        if let existing = dictionaries[language] {
            return existing
        }

        // Return existing loading task if in progress
        if let loadingTask = loadingTasks[language] {
            return try await loadingTask.value
        }

        // Start new loading task
        let loadingTask = Task<HunspellWrapper, Error> {
            let startTime = CFAbsoluteTimeGetCurrent()
            defer {
                let loadTime = CFAbsoluteTimeGetCurrent() - startTime
                Task { await recordLoadTime(language: language, time: loadTime) }
            }

            logger.info("Loading dictionary for \(language)")

            let dictionaryPath = try getDictionaryPath(for: language)
            let affixPath = try getAffixPath(for: language)

            let wrapper = try HunspellWrapper(
                dictionaryPath: dictionaryPath,
                affixPath: affixPath,
                language: language
            )

            logger.info("Dictionary loaded for \(language)")
            return wrapper
        }

        loadingTasks[language] = loadingTask

        do {
            let wrapper = try await loadingTask.value
            dictionaries[language] = wrapper
            loadingTasks.removeValue(forKey: language)
            return wrapper
        } catch {
            loadingTasks.removeValue(forKey: language)
            throw error
        }
    }

    /// Get dictionary for language (load if necessary)
    public func getDictionary(for language: Language) async throws -> HunspellWrapper {
        return try await loadDictionary(for: language)
    }

    /// Check if dictionary is loaded for language
    public func isDictionaryLoaded(for language: Language) -> Bool {
        return dictionaries[language] != nil
    }

    /// Get all loaded languages
    public var loadedLanguages: Set<Language> {
        Set(dictionaries.keys)
    }

    /// Preload all dictionaries (for startup optimization)
    public func preloadAllDictionaries() async {
        await withTaskGroup(of: Void.self) { group in
            for language in Language.allCases {
                group.addTask { [weak self] in
                    do {
                        _ = try await self?.loadDictionary(for: language)
                    } catch {
                        await self?.logger.error("Failed to preload \(language): \(error)")
                    }
                }
            }
        }
    }

    // MARK: - Private Helpers

    private func getDictionaryPath(for language: Language) throws -> String {
        let filename = "\(language.rawValue)_\(language.region).dic"
        guard let path = Bundle.main.path(forResource: filename, ofType: nil, inDirectory: "Dictionaries") else {
            throw ValidationError.dictionaryNotFound(language)
        }
        return path
    }

    private func getAffixPath(for language: Language) throws -> String {
        let filename = "\(language.rawValue)_\(language.region).aff"
        guard let path = Bundle.main.path(forResource: filename, ofType: nil, inDirectory: "Dictionaries") else {
            throw ValidationError.dictionaryNotFound(language)
        }
        return path
    }

    private func recordLoadTime(language: Language, time: TimeInterval) async {
        loadTimes[language] = time
        if time > 0.1 {  // 100ms threshold
            logger.warning("Slow dictionary load for \(language): \(time * 1000)ms")
        }
    }

    /// Get performance statistics
    public func getLoadTimes() -> [Language: TimeInterval] {
        loadTimes
    }
}

extension Language {
    var region: String {
        switch self {
        case .russian: return "RU"
        case .english: return "US"
        }
    }
}
```

#### 3. Implement Word Validation Cache (Est: 1.5h)

**Word Validation Cache:**
```swift
// Sources/SmartKeysCore/Validation/WordValidationCache.swift
import Foundation

/// LRU cache for word validation results to improve performance
public final class WordValidationCache: @unchecked Sendable {
    private struct CacheEntry {
        let result: ValidationResult
        let timestamp: TimeInterval
        var accessCount: Int
    }

    private var cache: [String: CacheEntry] = [:]
    private var accessOrder: [String] = []
    private let maxSize: Int
    private let maxAge: TimeInterval
    private let lock = NSLock()

    // Performance metrics
    private var hits: Int = 0
    private var misses: Int = 0

    public init(maxSize: Int = 1000, maxAge: TimeInterval = 300) {  // 5 minutes
        self.maxSize = maxSize
        self.maxAge = maxAge
    }

    /// Get cached validation result if available
    public func get(_ word: String, language: Language) -> ValidationResult? {
        lock.lock()
        defer { lock.unlock() }

        let key = cacheKey(word: word, language: language)

        guard var entry = cache[key] else {
            misses += 1
            return nil
        }

        // Check if entry is too old
        let now = CFAbsoluteTimeGetCurrent()
        if now - entry.timestamp > maxAge {
            cache.removeValue(forKey: key)
            accessOrder.removeAll { $0 == key }
            misses += 1
            return nil
        }

        // Update access tracking
        entry.accessCount += 1
        cache[key] = entry

        // Move to end of access order
        if let index = accessOrder.firstIndex(of: key) {
            accessOrder.remove(at: index)
        }
        accessOrder.append(key)

        hits += 1
        return entry.result
    }

    /// Store validation result in cache
    public func set(_ word: String, language: Language, result: ValidationResult) {
        lock.lock()
        defer { lock.unlock() }

        let key = cacheKey(word: word, language: language)
        let now = CFAbsoluteTimeGetCurrent()

        let entry = CacheEntry(
            result: result,
            timestamp: now,
            accessCount: 1
        )

        cache[key] = entry

        // Add to access order
        if let index = accessOrder.firstIndex(of: key) {
            accessOrder.remove(at: index)
        }
        accessOrder.append(key)

        // Enforce size limit
        while cache.count > maxSize && !accessOrder.isEmpty {
            let oldestKey = accessOrder.removeFirst()
            cache.removeValue(forKey: oldestKey)
        }
    }

    /// Clear expired entries
    public func cleanup() {
        lock.lock()
        defer { lock.unlock() }

        let now = CFAbsoluteTimeGetCurrent()
        var expiredKeys: [String] = []

        for (key, entry) in cache {
            if now - entry.timestamp > maxAge {
                expiredKeys.append(key)
            }
        }

        for key in expiredKeys {
            cache.removeValue(forKey: key)
            accessOrder.removeAll { $0 == key }
        }
    }

    /// Get cache statistics
    public func getStatistics() -> (hits: Int, misses: Int, hitRate: Double, size: Int) {
        lock.lock()
        defer { lock.unlock() }

        let total = hits + misses
        let hitRate = total > 0 ? Double(hits) / Double(total) : 0.0
        return (hits, misses, hitRate, cache.count)
    }

    private func cacheKey(word: String, language: Language) -> String {
        return "\(language.rawValue):\(word.lowercased())"
    }
}
```

#### 4. Implement Main Word Validator (Est: 2h)

**Hunspell Word Validator:**
```swift
// Sources/SmartKeysCore/Validation/HunspellWordValidator.swift
import Foundation
import Logging

/// Implementation of WordValidator using Hunspell dictionaries
@available(macOS 13.0, *)
public final class HunspellWordValidator: WordValidator {
    private let dictionaryManager: DictionaryManager
    private let cache: WordValidationCache
    private let logger: Logger

    // Performance tracking
    private var validationTimes: [TimeInterval] = []
    private let maxPerformanceSamples = 1000
    private let performanceLock = NSLock()

    public init(
        dictionaryManager: DictionaryManager? = nil,
        cache: WordValidationCache? = nil,
        logger: Logger = Logger(label: "WordValidator")
    ) {
        self.dictionaryManager = dictionaryManager ?? DictionaryManager(logger: logger)
        self.cache = cache ?? WordValidationCache()
        self.logger = logger
    }

    public func validate(_ word: String, language: Language) async -> ValidationResult {
        let startTime = CFAbsoluteTimeGetCurrent()

        defer {
            let validationTime = CFAbsoluteTimeGetCurrent() - startTime
            recordValidationTime(validationTime)
        }

        // Quick validation for empty or invalid input
        guard !word.isEmpty, word.count < 100 else {  // Reasonable word length limit
            return ValidationResult(isValid: false, suggestions: [], confidence: 0.0)
        }

        // Check cache first
        if let cachedResult = cache.get(word, language: language) {
            return cachedResult
        }

        // Perform actual validation
        let result = await performValidation(word: word, language: language)

        // Cache the result
        cache.set(word, language: language, result: result)

        return result
    }

    public func validateAllLanguages(_ word: String) async -> [Language: ValidationResult] {
        var results: [Language: ValidationResult] = [:]

        // Validate in parallel for better performance
        await withTaskGroup(of: (Language, ValidationResult).self) { group in
            for language in Language.allCases {
                group.addTask { [weak self] in
                    let result = await self?.validate(word, language: language) ?? ValidationResult(isValid: false)
                    return (language, result)
                }
            }

            for await (language, result) in group {
                results[language] = result
            }
        }

        return results
    }

    public var supportedLanguages: Set<Language> {
        get async {
            Set(Language.allCases)
        }
    }

    // MARK: - Private Implementation

    private func performValidation(word: String, language: Language) async -> ValidationResult {
        do {
            let dictionary = try await dictionaryManager.getDictionary(for: language)

            let isValid = dictionary.isValid(word)
            var suggestions: [String] = []
            var confidence: Float = 1.0

            if !isValid {
                // Get suggestions for invalid words
                suggestions = dictionary.getSuggestions(for: word, maxCount: 5)
                confidence = suggestions.isEmpty ? 0.5 : 0.8
            }

            return ValidationResult(
                isValid: isValid,
                suggestions: suggestions,
                confidence: confidence
            )

        } catch {
            logger.error("Dictionary validation failed for \(language): \(error)")
            // Return low-confidence result on error
            return ValidationResult(
                isValid: false,
                suggestions: [],
                confidence: 0.1
            )
        }
    }

    private func recordValidationTime(_ time: TimeInterval) {
        performanceLock.lock()
        defer { performanceLock.unlock() }

        validationTimes.append(time)

        // Keep only recent samples
        if validationTimes.count > maxPerformanceSamples {
            validationTimes.removeFirst()
        }

        // Log warning if validation is too slow
        if time > 0.001 {  // 1ms threshold
            logger.warning("Slow word validation: \(time * 1000)ms")
        }
    }

    /// Get performance statistics
    public func getPerformanceStats() -> (avg: TimeInterval, p95: TimeInterval, p99: TimeInterval) {
        performanceLock.lock()
        defer { performanceLock.unlock() }

        guard !validationTimes.isEmpty else {
            return (0, 0, 0)
        }

        let sorted = validationTimes.sorted()
        let avg = sorted.reduce(0, +) / Double(sorted.count)
        let p95Index = min(Int(Double(sorted.count) * 0.95), sorted.count - 1)
        let p99Index = min(Int(Double(sorted.count) * 0.99), sorted.count - 1)

        return (avg, sorted[p95Index], sorted[p99Index])
    }

    /// Get cache performance statistics
    public func getCacheStats() -> (hits: Int, misses: Int, hitRate: Double, size: Int) {
        return cache.getStatistics()
    }
}
```

#### 5. Integrate with Factory DI (Est: 30min)

**Update Core Container:**
```swift
// Sources/SmartKeysCore/DI/CoreContainer.swift
import Factory
import Logging

extension Container {
    var wordValidator: Factory<WordValidator> {
        self {
            let logger = Logger(label: "SmartKeys.WordValidator")
            let dictionaryManager = DictionaryManager(logger: logger)
            let cache = WordValidationCache()
            return HunspellWordValidator(dictionaryManager: dictionaryManager, cache: cache, logger: logger)
        }
    }
}
```

## ⚠️ Critical Boundaries

### Scope IN (What this task changes)
- Complete Hunspell C API integration for word validation
- Russian and English dictionary loading and management
- High-performance word validation with <1ms requirement
- Intelligent caching system for repeated validations
- Thread-safe implementation for concurrent access

### Scope OUT (What this task does NOT touch)
- ❌ Layout correction logic (handled in SMK-005)
- ❌ Dictionary file creation or modification (use existing dictionaries)
- ❌ Language detection (basic language parameter only)
- ❌ Custom dictionary management (use standard Hunspell format)

### Performance Requirements (CRITICAL)
- **Validation Latency**: <1ms per word (95th percentile)
- **Dictionary Loading**: <100ms startup time for all dictionaries
- **Memory Usage**: <30MB total for all loaded dictionaries
- **Cache Hit Rate**: >80% for repeated word validations
- **Concurrent Access**: Support multiple simultaneous validations

### Dictionary Requirements
- Must use standard Hunspell dictionary format (.dic/.aff files)
- Russian morphological analysis support
- English spelling validation
- Graceful handling of missing or corrupted dictionary files

## 🧪 Acceptance Tests

### Manual Tests (for reviewer)

1. **Basic Validation Test:**
   ```swift
   let validator = Container.shared.wordValidator()

   let russianResult = await validator.validate("привет", language: .russian)
   XCTAssertTrue(russianResult.isValid)

   let englishResult = await validator.validate("hello", language: .english)
   XCTAssertTrue(englishResult.isValid)
   ```
   ✅ Expected: Common words validate correctly

2. **Misspelled Word Test:**
   ```swift
   let result = await validator.validate("helo", language: .english)
   XCTAssertFalse(result.isValid)
   XCTAssertTrue(result.suggestions.contains("hello"))
   ```
   ✅ Expected: Misspelled words return suggestions

3. **Performance Test:**
   ```swift
   let result = await PerformanceTestHelpers.assertPerformance({
       return await validator.validate("example", language: .english)
   }, completesWithin: 0.001)  // 1ms requirement
   ```
   ✅ Expected: Validation completes within 1ms

### Automated Tests

```swift
// Tests/SmartKeysCoreTests/Unit/WordValidatorTests.swift
final class WordValidatorTests: XCTestCase {

    func testDictionaryLoading() async throws {
        let validator = Container.shared.wordValidator()

        let supportedLangs = await validator.supportedLanguages
        XCTAssertTrue(supportedLangs.contains(.russian))
        XCTAssertTrue(supportedLangs.contains(.english))
    }

    func testValidationAccuracy() async {
        let validator = Container.shared.wordValidator()

        // Test valid words
        let validWords = [
            ("привет", Language.russian),
            ("спасибо", Language.russian),
            ("hello", Language.english),
            ("world", Language.english)
        ]

        for (word, language) in validWords {
            let result = await validator.validate(word, language: language)
            XCTAssertTrue(result.isValid, "\(word) should be valid in \(language)")
        }
    }

    func testCachePerformance() async {
        let validator = Container.shared.wordValidator()

        // First validation (cache miss)
        let _ = await validator.validate("test", language: .english)

        // Second validation (cache hit) - should be faster
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = await validator.validate("test", language: .english)
        let cacheHitTime = CFAbsoluteTimeGetCurrent() - startTime

        XCTAssertLessThan(cacheHitTime, 0.0001, "Cache hit should be very fast")
    }
}
```

### Performance Validation
- All validation operations complete within 1ms (95th percentile)
- Dictionary loading completes within 100ms for all languages
- Cache hit rate >80% after warm-up period
- Memory usage stays under 30MB for all dictionaries
- No memory leaks during extended operation

## 📝 Notes for Developer

**Hunspell Integration Tips:**
- Handle C memory management carefully (use defer for cleanup)
- Test with actual dictionary files from Hunspell distribution
- Verify morphological analysis works for Russian words
- Handle encoding issues correctly (UTF-8)

**Performance Optimization:**
- Cache is critical for achieving <1ms validation
- Preload dictionaries during app startup for better UX
- Use async/await properly to avoid blocking
- Profile memory usage with large dictionaries

**Error Handling Strategy:**
- Graceful degradation when dictionaries are missing
- Log errors but don't crash the application
- Provide meaningful fallbacks for validation failures
- Handle corrupted dictionary files gracefully

**Common Pitfalls:**
- Don't forget to free Hunspell memory allocations
- Handle thread safety properly for cache access
- Test with realistic word patterns and lengths
- Ensure proper cleanup on app termination

**Next Steps After Completion:**
- SMK-005 correction engine will use this for better correction decisions
- Performance testing will validate the 1ms requirement
- Integration testing will test with real user workflows
- Future enhancements may add custom dictionary support