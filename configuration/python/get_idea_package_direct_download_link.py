import utils
import re
def get_idea_package_direct_download_link():
  html_content = utils.download_html("https://www.jetbrains.com/intellij-repository/releases")
  second_part=html_content.split("com.jetbrains.intellij.idea")
  results = re.search("(?<=<td>)([0-9]|\.)*(?=</td>)", second_part[1])
  version = results[0]
  print("https://download.jetbrains.com/idea/ideaIC-" + version + ".tar.gz")
if __name__ == "__main__":
  get_idea_package_direct_download_link()
