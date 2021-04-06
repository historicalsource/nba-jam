rem srec < bb.lrn
copy /b bbf8.0+bbfa.0+bbfc.0+bbfe.0 7m.0
copy /b bbf8.1+bbfa.1+bbfc.1+bbfe.1 7m.1
dataio 7m.0
dataio 7m.1
