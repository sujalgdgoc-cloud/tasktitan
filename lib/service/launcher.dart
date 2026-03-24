
import 'package:url_launcher/url_launcher.dart';
class Launcher{
  Future<void> openGitHub(String githubLink) async {
    if (githubLink.isEmpty) return;

    final Uri url = Uri.parse(githubLink);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
