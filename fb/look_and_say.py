import itertools as I

def look_and_say(x0):
    yield x0
    say = str(x0)
    while len(say) < 100:
        newsay = ''
        for digit, lst in I.groupby(say):
            newsay += '%s%s' % (len(list(lst)), digit)
        yield int(newsay)
        say = newsay

print list(look_and_say(1))
