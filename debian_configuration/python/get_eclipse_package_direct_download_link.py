import requests
import utils
import re
DOWNLOAD_HOST = 'https://www.eclipse.org/downloads/'
def _download_html(url:str)->str: 
  headers={'user-agent':'Linux'}
  response = requests.get(url, headers=headers) 
  encoding_type = response.encoding
  return response.content.decode(encoding_type)
  
def _get_download_link()->str:
  global DOWNLOAD_HOST
  html_content = _download_html(DOWNLOAD_HOST+'/packages/') 
  result = utils.get_str(html_content, "eclipse-jee-.*tar.gz$", "'", False)
  return result.replace("//www","https://www")

def get_eclipse_package_direct_download_link():
  download_link = _get_download_link()
  downloaded_html = _download_html(download_link)
  global DOWNLOAD_HOST
  mirror_link_str = DOWNLOAD_HOST + utils.get_str(downloaded_html,'mirror_id=','"', False)
  final_downloaded_html = _download_html(mirror_link_str)
  refresh_metadata_tag = utils.get_str(final_downloaded_html,'Refresh','><', False)
  direct_download_link=re.search('https.*.tar.gz', refresh_metadata_tag).group(0)
  print(direct_download_link)

if __name__ == "__main__":
  get_eclipse_package_direct_download_link()
