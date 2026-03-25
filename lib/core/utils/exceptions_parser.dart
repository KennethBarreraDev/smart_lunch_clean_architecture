class ExceptionsParser {
  static String getMessageFromException(Object e) {
    String errorMessage = "unknown_error";

    if (e is Exception) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
    }
    return errorMessage;
  }
}
