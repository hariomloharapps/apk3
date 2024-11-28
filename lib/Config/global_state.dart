import 'package:shared_preferences/shared_preferences.dart';

class GlobalState {
  // Singleton instance
  static final GlobalState _instance = GlobalState._internal();

  // Private constructor
  GlobalState._internal();

  // Factory constructor to return the singleton instance
  factory GlobalState() {
    return _instance;
  }

  // Keys for SharedPreferences
  static const String _userIdKey = 'user_id';
  static const String _personalityIdKey = 'personality_id';
  static const String _colorKey = 'color';
  static const String _initialSetupCompletedKey = 'initial_setup_completed';
  static const String _subscriptionEndDateKey = 'subscription_end_date'; // New key
  static const String _isSubscribedKey = 'is_subscribed'; // New key

  // Store values in memory
  String? _userId;
  String? _personalityId;
  String? _color;
  bool _initialSetupCompleted = false;
  DateTime? _subscriptionEndDate; // New variable
  bool _isSubscribed = false; // New variable

  // Track initialization state
  bool _isInitialized = false;

  // Getters
  String? get userId => _userId;
  String? get personalityId => _personalityId;
  String? get color => _color;
  bool get initialSetupCompleted => _initialSetupCompleted;
  DateTime? get subscriptionEndDate => _subscriptionEndDate; // New getter
  bool get isSubscribed => _isSubscribed; // New getter

  // New subscription setters
  Future<void> setSubscriptionEndDate(DateTime? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == null) {
      if (await _hasValue(_subscriptionEndDateKey)) {
        await prefs.remove(_subscriptionEndDateKey);
        _subscriptionEndDate = null;
        print('Subscription end date cleared');
      }
    } else {
      await prefs.setString(_subscriptionEndDateKey, value.toIso8601String());
      _subscriptionEndDate = value;
      print('Subscription end date set to: $value');
    }
  }

  Future<void> setIsSubscribed(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSubscribedKey, value);
    _isSubscribed = value;
    print('Subscription status set to: $value');
  }

  // Existing setters
  Future<void> setInitialSetupCompleted(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_initialSetupCompletedKey, value);
    _initialSetupCompleted = value;
    print('Initial setup completed status set to: $value');
  }

  Future<bool> _hasValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<void> setUserId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == null) {
      if (await _hasValue(_userIdKey)) {
        await prefs.remove(_userIdKey);
        _userId = null;
        print('User ID cleared');
      }
    } else {
      await prefs.setString(_userIdKey, value);
      _userId = value;
      print('User ID set to: $value');
    }
  }

  Future<void> setPersonalityId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == null) {
      if (await _hasValue(_personalityIdKey)) {
        await prefs.remove(_personalityIdKey);
        _personalityId = null;
        print('Personality ID cleared');
      }
    } else {
      await prefs.setString(_personalityIdKey, value);
      _personalityId = value;
      print('Personality ID set to: $value');
    }
  }

  Future<void> setColor(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == null) {
      if (await _hasValue(_colorKey)) {
        await prefs.remove(_colorKey);
        _color = null;
        print('Color cleared');
      }
    } else {
      await prefs.setString(_colorKey, value);
      _color = value;
      print('Color set to: $value');
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (await _hasValue(_userIdKey)) {
        _userId = prefs.getString(_userIdKey);
        print('Loaded existing User ID: $_userId');
      }

      if (await _hasValue(_personalityIdKey)) {
        _personalityId = prefs.getString(_personalityIdKey);
        print('Loaded existing Personality ID: $_personalityId');
      }

      if (await _hasValue(_colorKey)) {
        _color = prefs.getString(_colorKey);
        print('Loaded existing Color: $_color');
      }

      if (await _hasValue(_initialSetupCompletedKey)) {
        _initialSetupCompleted = prefs.getBool(_initialSetupCompletedKey) ?? false;
        print('Loaded initial setup status: $_initialSetupCompleted');
      }

      // Load subscription data
      if (await _hasValue(_subscriptionEndDateKey)) {
        final dateStr = prefs.getString(_subscriptionEndDateKey);
        _subscriptionEndDate = dateStr != null ? DateTime.parse(dateStr) : null;
        print('Loaded subscription end date: $_subscriptionEndDate');
      }

      if (await _hasValue(_isSubscribedKey)) {
        _isSubscribed = prefs.getBool(_isSubscribedKey) ?? false;
        print('Loaded subscription status: $_isSubscribed');
      }

      _isInitialized = true;
      print('GlobalState initialized');
    } catch (e) {
      print('Error in GlobalState initialization: $e');
      rethrow;
    }
  }

  // Check methods
  Future<bool> hasUserId() => _hasValue(_userIdKey);
  Future<bool> hasPersonalityId() => _hasValue(_personalityIdKey);
  Future<bool> hasColor() => _hasValue(_colorKey);
  Future<bool> hasInitialSetupCompleted() => _hasValue(_initialSetupCompletedKey);
  Future<bool> hasSubscriptionEndDate() => _hasValue(_subscriptionEndDateKey); // New check method
  Future<bool> hasIsSubscribed() => _hasValue(_isSubscribedKey); // New check method

  // Clear methods
  Future<void> clearUserId() => setUserId(null);
  Future<void> clearPersonalityId() => setPersonalityId(null);
  Future<void> clearColor() => setColor(null);
  Future<void> clearSubscriptionEndDate() => setSubscriptionEndDate(null); // New clear method

  Future<void> clearAll() async {
    await clearUserId();
    await clearPersonalityId();
    await clearColor();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_initialSetupCompletedKey);
    await prefs.remove(_subscriptionEndDateKey); // Clear subscription end date
    await prefs.remove(_isSubscribedKey); // Clear subscription status
    _initialSetupCompleted = false;
    _subscriptionEndDate = null;
    _isSubscribed = false;
    print('All values cleared');
  }
}