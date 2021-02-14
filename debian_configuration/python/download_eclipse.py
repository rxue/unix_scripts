import requests
DOWNLOAD_HOST = 'https://www.eclipse.org/downloads/'
def _download_html(url:str)->str: 
  headers={'user-agent':'Linux'}
  response = requests.get(url, headers=headers) 
  encoding_type = response.encoding
  return response.content.decode(encoding_type)
def _get_str(html_content:str,keyword:str,split_by='"')->str:
  for splitted in html_content.split(split_by):
    if keyword in splitted:
      return splitted
  
def _get_download_link()->str:
  global DOWNLOAD_HOST
  html_content = _download_html(DOWNLOAD_HOST) 
  return _get_str(html_content,'tar.gz')

def download_eclipse():
  download_link = _get_download_link()
  downloaded_html = _download_html(download_link)
  global DOWNLOAD_HOST
  mirror_link_str = DOWNLOAD_HOST + _get_str(downloaded_html,'mirror_id=')
  downloaded_html = _download_html(mirror_link_str)
  refresh_metadata_tag = _get_str(downloaded_html,'Refresh','><')
  direct_download_link = _get_str(refresh_metadata_tag,'https','=').replace('"','')
  file_name = direct_download_link.split('/')[-1]
  with requests.get(direct_download_link) as inp:
    with open(file_name, 'wb') as outp:
      outp.write(inp.content) 
if __name__ == "__main__":
  download_eclipse()
