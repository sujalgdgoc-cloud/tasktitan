class ProgressValidationService {
  DateTime? _startTime;

  void markStartTime() {
    _startTime = DateTime.now();
  }

  bool validateGitHubLink(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) return false;

    if (!uri.host.contains("github.com")) return false;

    if (!uri.pathSegments.contains("commit") &&
        !uri.pathSegments.contains("pull")) {
      return false;
    }

    return true;
  }

  bool validateWorkDuration() {
    if (_startTime == null) return false;

    final diff = DateTime.now().difference(_startTime!);
    return diff.inMinutes >= 2;
  }

  Future<String?> validateBeforeDone({
    required String submittedLink,
  }) async {
    if (submittedLink.isEmpty) {
      return "Please enter your GitHub commit / PR link";
    }

    if (!validateGitHubLink(submittedLink)) {
      return "Invalid GitHub commit or PR link";
    }

    if (!validateWorkDuration()) {
      return "Too fast! Work looks suspicious";
    }

    return null;
  }
}