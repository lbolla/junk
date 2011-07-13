import logging
import sys
from httplib import HTTPConnection
from urllib2 import mimetools
from urlparse import urlparse

try:
    import html2text
except ImportError:
    html2text = None


def w3c_validate(html_str):

    url = 'http://validator.w3.org/check'
    scheme, netloc, path, params, query, fragment = urlparse(url)

    boundary = mimetools.choose_boundary()
    headers = {'Content-type': 'multipart/form-data',
            'boundary': boundary}
    options = [('charset', '(detect automatically)'),
            ('doctype', 'Inline'),
            ('group',   '0')]
    files = [('uploaded_file', 'test.html', 'text/html', html_str)]

    params = []
    for f in files:
        params.append('--' + boundary)
        params.append('Content-Disposition: form-data; name="%s"; filename="%s"' %
                (f[0], f[1]))
        params.append('Content-Type: %s' % f[2])
        params.append('')
        params.append(f[3])
    for opt in options:
        params.append('--' + boundary)
        params.append('Content-Disposition: form-data; name="%s"' %
                opt[0])
        params.append('')
        params.append(opt[1])

    params.append('--' + boundary + '--')
    params.append('')

    CRLF = '\r\n'
    data = CRLF.join(params)

    conn = HTTPConnection(netloc)
    #conn.debuglevel = 1
    conn.request('POST', path, data, headers)
    response = conn.getresponse()
    conn.close()

    if response.getheader('x-w3c-validator-status') == 'Valid':
        logging.info('Valid!')
        return True
    else:
        nerrors   = response.getheader('x-w3c-validator-errors')
        nwarnings = response.getheader('x-w3c-validator-warnings')
        logging.error('Invalid! %s errors / %s warnings', nerrors, nwarnings)
        if html2text:
            logging.warning(html2text.html2text(response.read().decode('ascii', 'ignore'), ''))
        return False


def main():
    if len(sys.argv) > 1:
        html_str = open(sys.argv[1], 'r').read()
    else:
        html_str = sys.stdin.read()

    if w3c_validate(html_str):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == '__main__':
    main()
