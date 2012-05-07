from tables import *

class Particle(IsDescription):
    name = StringCol(16)
    idnumber = Int64Col()

h5file = openFile('tutorial1.h5', mode='w', title='test file')
group = h5file.createGroup('/', 'detector', 'Detector Information')
table = h5file.createTable(group, 'readout', Particle, 'Readout example')

print h5file

particle = table.row

for i in xrange(10):
    particle['name'] = 'particle %d' % i
    particle['idnumber'] = i
    particle.append()

table.flush()

print h5file
