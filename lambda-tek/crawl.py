import csv
import urllib2
import htmllib
import urlparse
from BeautifulSoup import BeautifulSoup


def unescape(s):
    p = htmllib.HTMLParser(None)
    p.save_bgn()
    p.feed(s)
    return p.save_end()


def get_text(ent):
    if ent is None or ent.text is None:
        return u''
    return unescape(ent.getText(' '))


def extract_data(url):
    req = urllib2.urlopen(url)
    html = req.read()
    doc = BeautifulSoup(html)

    breadcrumb = doc.find('div', id='BreadCrumb')
    categories = [a.string for a in breadcrumb.findAll('a')]

    name = get_text(doc.find('h1', itemprop='name'))

    description = get_text(doc.find('p', itemprop='description'))

    details = get_text(doc.find('span', id='webcollage_ppp'))
    details = details.replace('BEGIN_WEBCOLLAGE', '')
    details = details.replace('END_WEBCOLLAGE', '')

    return categories, ' '.join([name, description, details])


def main():
    with open('lambda-tek.csv', 'w') as fd:
        dialect = csv.excel
        dialect.quoting = csv.QUOTE_ALL
        output = csv.writer(fd, dialect=dialect)
        urls = crawl('http://www.lambda-tek.com/' \
                'componentshop/index.pl?region=GB')
        for url in urls:
            try:
                print url
                categories, data = extract_data(url)
                # Save top level category only
                output.writerow([categories[0], data.encode('ascii',
                    'ignore')])
            except Exception as exc:
                print 'ERROR', exc


def crawl(url):
    to_crawl = set()
    to_crawl.add(url)
    visited = set()
    extracted = set()

    while to_crawl:
        print len(to_crawl), len(visited), len(extracted)

        url = to_crawl.pop()
        if url in visited:
            continue
        visited.add(url)

        req = urllib2.urlopen(url)
        html = req.read()
        doc = BeautifulSoup(html)

        if not doc:
            continue

        for a in doc.findAll('a'):
            url = urlparse.urlparse(dict(a.attrs).get('href', ''))

            if not url or \
                    url.scheme != 'http' or \
                    url.hostname != 'www.lambda-tek.com':
                continue

            raw_url = url.geturl()
            if url.path.startswith('/componentshop/index.pl'):
                to_crawl.add(raw_url)

            elif raw_url not in extracted:
                yield url.geturl()
                extracted.add(url.geturl())


if __name__ == '__main__':
    main()
