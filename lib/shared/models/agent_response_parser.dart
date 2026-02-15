import 'dart:convert';
import 'agent_response.dart';

class AgentResponseParser {
  static AgentResponse parseResponse(String responseText) {
    try {
      // Check for mixed format (text + JSON block with markdown)
      if (responseText.contains('```json') && responseText.contains('```')) {
        final jsonStart = responseText.indexOf('```json') + 7;
        final jsonEnd = responseText.lastIndexOf('```');
        
        if (jsonStart < jsonEnd) {
          final jsonPart = responseText.substring(jsonStart, jsonEnd).trim();
          final textPart = responseText.substring(0, responseText.indexOf('```json')).trim();
          
          try {
            final jsonData = json.decode(jsonPart);
            if (jsonData is Map<String, dynamic>) {
              final message = textPart.isNotEmpty ? textPart : (jsonData['message']?.toString() ?? responseText);
              
              return AgentResponse(
                agentType: _detectAgentType(jsonData),
                responseType: ResponseType.structured,
                message: message,
                structuredData: jsonData,
                rawText: responseText,
              );
            }
          } catch (e) {
            // JSON parsing failed, continue with other methods
          }
        }
      }
      
      // Check for mixed format (text + JSON without markdown)
      if (responseText.contains('{') && responseText.contains('}')) {
        final jsonStart = responseText.indexOf('{');
        final jsonEnd = responseText.lastIndexOf('}') + 1;
        
        if (jsonStart > 0 && jsonEnd > jsonStart) {
          final textPart = responseText.substring(0, jsonStart).trim();
          final jsonPart = responseText.substring(jsonStart, jsonEnd).trim();
          
          try {
            final jsonData = json.decode(jsonPart);
            if (jsonData is Map<String, dynamic>) {
              // Use text part as message if it's substantial, otherwise use JSON message
              final message = (textPart.length > 10) ? textPart : (jsonData['message']?.toString() ?? responseText);
              
              return AgentResponse(
                agentType: _detectAgentType(jsonData),
                responseType: ResponseType.structured,
                message: message,
                structuredData: jsonData,
                rawText: responseText,
              );
            }
          } catch (e) {
            // JSON parsing failed, continue with other methods
          }
        }
      }
      
      // Clean markdown code blocks if present
      String cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json') && cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(7, cleanedText.length - 3).trim();
      } else if (cleanedText.startsWith('```') && cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(3, cleanedText.length - 3).trim();
      }
      
      // Try to parse as JSON
      final jsonData = json.decode(cleanedText);
      
      if (jsonData is Map<String, dynamic>) {
        return _parseStructuredResponse(jsonData, responseText);
      }
    } catch (e) {
      // Not JSON, treat as plain text
    }
    
    return _parsePlainTextResponse(responseText);
  }

  static AgentResponse _parseStructuredResponse(Map<String, dynamic> data, String rawText) {
    final agentType = _detectAgentType(data);
    
    // Extract message - handle different response formats
    String message = '';
    if (data.containsKey('message')) {
      message = data['message']?.toString() ?? '';
    } else if (data.containsKey('summary')) {
      // SEBI and Debt Squares use 'summary' field
      message = data['summary']?.toString() ?? '';
    } else {
      message = rawText;
    }
    
    return AgentResponse(
      agentType: agentType,
      responseType: ResponseType.structured,
      message: message,
      structuredData: data,
      rawText: rawText,
    );
  }

  static AgentResponse _parsePlainTextResponse(String text) {
    return AgentResponse(
      agentType: AgentType.generic,
      responseType: ResponseType.plainText,
      message: text,
      rawText: text,
    );
  }

  static AgentType _detectAgentType(Map<String, dynamic> data) {
    // Tax Mitra detection
    if (_isTaxMitraResponse(data)) {
      return AgentType.taxMitra;
    }
    
    // Trader Agent detection
    if (_isTraderResponse(data)) {
      return AgentType.trader;
    }
    
    // Debt Squares detection
    if (_isDebtSquaresResponse(data)) {
      return AgentType.debtSquares;
    }
    
    // SEBI Compliance detection
    if (_isSebiComplianceResponse(data)) {
      return AgentType.sebiCompliance;
    }
    
    return AgentType.generic;
  }

  static bool _isTaxMitraResponse(Map<String, dynamic> data) {
    // Strong indicators of Tax Mitra
    if (data.containsKey('progress') || 
        data.containsKey('questions') ||
        data['action'] != null) {
      return true;
    }
    
    // Check for tax-specific keywords in message
    final message = data['message']?.toString().toLowerCase() ?? '';
    final taxKeywords = ['tax', 'itr', 'deduction', 'income', 'refund', 'filing'];
    
    return taxKeywords.any((keyword) => message.contains(keyword));
  }

  static bool _isTraderResponse(Map<String, dynamic> data) {
    // Check for trader-specific fields in data
    final dataObj = data['data'] as Map<String, dynamic>?;
    if (dataObj != null) {
      final traderFields = ['auth_status', 'symbol_info', 'trade_confirmation', 
                           'order_result', 'portfolio', 'user_profile'];
      if (traderFields.any((field) => dataObj.containsKey(field))) {
        return true;
      }
    }
    
    // Check for trader-specific actions
    final action = data['action']?.toString();
    if (action == 'auth_required' || action == 'confirmation_required') {
      return true;
    }
    
    // Check for trading keywords in message
    final message = data['message']?.toString().toLowerCase() ?? '';
    final traderKeywords = ['buy', 'sell', 'stock', 'trade', 'portfolio', 'order', 'zerodha'];
    
    return traderKeywords.any((keyword) => message.contains(keyword));
  }

  static bool _isDebtSquaresResponse(Map<String, dynamic> data) {
    // Check for debt-specific fields in data
    final dataObj = data['data'] as Map<String, dynamic>?;
    if (dataObj != null) {
      final debtFields = ['total_debt', 'monthly_payment_goal', 'target_duration_months', 
                         'recommended_actions', 'debt_free_by'];
      if (debtFields.any((field) => dataObj.containsKey(field))) {
        return true;
      }
    }
    
    // Check for debt keywords in message
    final message = data['message']?.toString().toLowerCase() ?? '';
    final debtKeywords = ['debt', 'loan', 'emi', 'credit card', 'debt-free', 'payment'];
    
    return debtKeywords.any((keyword) => message.contains(keyword));
  }

  static bool _isSebiComplianceResponse(Map<String, dynamic> data) {
    // Check for SEBI-specific fields in data
    final dataObj = data['data'] as Map<String, dynamic>?;
    if (dataObj != null) {
      final sebiFields = ['compliance_score', 'potential_anomalies', 'alert_flag'];
      if (sebiFields.any((field) => dataObj.containsKey(field))) {
        return true;
      }
    }
    
    // Check for SEBI keywords in message
    final message = data['message']?.toString().toLowerCase() ?? '';
    final sebiKeywords = ['sebi', 'compliance', 'regulation', 'anomaly', 'violation'];
    
    return sebiKeywords.any((keyword) => message.contains(keyword));
  }
}