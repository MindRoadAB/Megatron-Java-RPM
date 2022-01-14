all: rpm

MEGATRON_DIST := https://www.cert.se/megatron/megatron-pub-1.1.0.tar.gz
MEGATRON_DIST_MD5 = 816a6b9644cc929822e861221b07ea37

GEOIP_COUNTRY_DB := https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz
GEOIP_ASN_DB := https://dl.miyuru.lk/geoip/maxmind/asn/maxmind4.dat.gz
GEOIP_CITY_DB := https://dl.miyuru.lk/geoip/maxmind/city/maxmind4.dat.gz

rpm:
	mkdir BUILD
	mkdir BUILDROOT
	mkdir SOURCES
	mkdir SPECS
	mkdir RPMS
	mkdir SRPMS

	mkdir BUILD/geoip-db
	wget -O - $(GEOIP_COUNTRY_DB) | gunzip -c > BUILD/geoip-db/GeoIP.dat
	wget -O - $(GEOIP_ASN_DB) | gunzip -c > BUILD/geoip-db/GeoIPASNum.dat
	wget -O - $(GEOIP_CITY_DB) | gunzip -c > BUILD/geoip-db/GeoLiteCity.dat

	cp megatron.spec SPECS/

	wget -O SOURCES/megatron.tar.gz $(MEGATRON_DIST) 
	echo "$(MEGATRON_DIST_MD5)  SOURCES/megatron.tar.gz" | md5sum -c
	tar -xf SOURCES/megatron.tar.gz -C BUILD/

	cp -r megatron BUILD/

	rpmbuild --define "_topdir `pwd`" -bb SPECS/megatron.spec

	cp RPMS/noarch/* .

clean:
	rm -rf BUILD
	rm -rf BUILDROOT
	rm -rf SOURCES
	rm -rf SPECS
	rm -rf RPMS
	rm -rf SRPMS
	rm -f *.rpm

