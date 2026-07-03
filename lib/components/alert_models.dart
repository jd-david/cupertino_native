/// Style for an alert action.
enum CNAlertActionStyle {
  /// The default style for the action's button.
  defaultStyle,

  /// A style that indicates the action might change or delete data.
  destructive,

  /// A style that indicates the action cancels the operation and leaves things unchanged.
  cancel,
}

/// An action to display in an alert.
class CNAlertAction {
  /// The text to display for the action.
  final String title;

  /// The style of the action.
  final CNAlertActionStyle style;

  /// Whether the action is enabled.
  final bool isEnabled;

  /// Creates a new alert action.
  const CNAlertAction({
    required this.title,
    this.style = CNAlertActionStyle.defaultStyle,
    this.isEnabled = true,
  });

  /// Converts this action to a map for the method channel.
  Map<String, dynamic> toMap() {
    return {'title': title, 'style': style.name, 'isEnabled': isEnabled};
  }
}

/// A text field to display in an alert.
class CNAlertTextField {
  /// The placeholder text to display in the text field.
  final String? placeholder;

  /// The initial text of the text field.
  final String? text;

  /// Whether the text field should obscure its content (e.g., for passwords).
  final bool secureTextEntry;

  /// Creates a new alert text field.
  const CNAlertTextField({
    this.placeholder,
    this.text,
    this.secureTextEntry = false,
  });

  /// Converts this text field to a map for the method channel.
  Map<String, dynamic> toMap() {
    return {
      'placeholder': placeholder,
      'text': text,
      'secureTextEntry': secureTextEntry,
    };
  }
}

/// The result of an alert interaction.
class CNAlertResult {
  /// The index of the action that the user tapped.
  final int actionIndex;

  /// The text values entered into any text fields, in the order they were provided.
  final List<String> textFields;

  /// Creates a new alert result.
  const CNAlertResult({required this.actionIndex, this.textFields = const []});

  /// Creates a new alert result from a map.
  factory CNAlertResult.fromMap(Map<dynamic, dynamic> map) {
    return CNAlertResult(
      actionIndex: map['actionIndex'] as int,
      textFields: (map['textFields'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
