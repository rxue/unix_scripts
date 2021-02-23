import requests
import sys
import re
DOWNLOAD_HOST = 'https://www.eclipse.org/downloads/'
def _download_html(url:str)->str: 
  headers={'user-agent':'Linux','Upgrade-Insecure-Requests':'1'}
  response = requests.get(url, headers=headers) 
  encoding_type = response.encoding
  return response.content.decode(encoding_type)
def _get_str(html_content:str,regex:str,split_by:str='"')->str:
  for splitted in html_content.split(split_by):
    if re.search(regex,splitted):
      return splitted
  
def _get_download_link()->str:
  global DOWNLOAD_HOST
  html_content = _download_html(DOWNLOAD_HOST+'/packages/') 
  result = _get_str(html_content, "eclipse-jee-.*tar.gz$", "'")
  return result.replace("//www","https://www")

def download_eclipse_jee_package(to_dir:str=''):
  download_link = _get_download_link()
  downloaded_html = _download_html(download_link)
  global DOWNLOAD_HOST
  mirror_link_str = DOWNLOAD_HOST + _get_str(downloaded_html,'mirror_id=')
  print(mirror_link_str)
  final_downloaded_html = _download_html(mirror_link_str)
  refresh_metadata_tag = _get_str(final_downloaded_html,'Refresh','><')
  direct_download_link=re.search('https.*.tar.gz', refresh_metadata_tag).group(0)
  file_name = direct_download_link.split('/')[-1]
  if len(to_dir) > 0:
    file_name = to_dir + "/" + file_name
  print("Going to download from",direct_download_link)
  with requests.get(direct_download_link,stream=True) as inp:
    with open(file_name, "wb") as outp:
      for chunk in inp.iter_content(chunk_size=1024):
        if chunk:
          outp.write(chunk)
          outp.flush() 
  print(file_name)

if __name__ == "__main__":
  if len(sys.argv) > 1:
    download_eclipse_jee_package(sys.argv[1])
  else:
    download_eclipse_jee_package()
