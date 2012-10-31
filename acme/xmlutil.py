def _getText(root, rc):
    for node in root.childNodes:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data.encode('utf-8'))
        _getText(node, rc)
    return rc


def getText(root):
    rc = []
    _getText(root, rc)
    return ''.join(rc)
