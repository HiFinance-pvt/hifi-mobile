enum AgentType {
  taxMitra,
  trader,
  debtSquares,
  sebiCompliance,
  generic,
  unknown
}

enum ResponseType {
  structured,
  plainText
}

class AgentResponse {
  final AgentType agentType;
  final ResponseType responseType;
  final String message;
  final Map<String, dynamic>? structuredData;
  final String rawText;

  AgentResponse({
    required this.agentType,
    required this.responseType,
    required this.message,
    this.structuredData,
    required this.rawText,
  });

  bool get hasQuestions => structuredData?['questions'] != null;
  bool get hasProgress => structuredData?['progress'] != null;
  bool get hasData => structuredData?['data'] != null;
  String? get action => structuredData?['action'];
  String? get status => structuredData?['status'];
}