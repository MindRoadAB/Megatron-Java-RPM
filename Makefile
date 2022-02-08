all: rpm

MEGATRON_DIST := https://www.cert.se/megatron/megatron-pub-1.1.0.tar.gz
MEGATRON_DIST_MD5 := 816a6b9644cc929822e861221b07ea37

GEOIP_COUNTRY_DB := https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz
GEOIP_ASN_DB := https://dl.miyuru.lk/geoip/maxmind/asn/maxmind4.dat.gz
GEOIP_CITY_DB := https://dl.miyuru.lk/geoip/maxmind/city/maxmind4.dat.gz

LOG4J_DIST := https://archive.apache.org/dist/logging/log4j/2.17.1/apache-log4j-2.17.1-bin.tar.gz
LOG4J_SHA256SUM := b876c20c9d318d77a39c0c2e095897b2bb1cd100c7859643f8c7c8b0fc6d5961

rpm:
	mkdir BUILD
	mkdir BUILDROOT
	mkdir SOURCES
	mkdir SPECS
	mkdir RPMS
	mkdir SRPMS
	mkdir log4j_dist

	mkdir BUILD/geoip-db
	wget -O - $(GEOIP_COUNTRY_DB) | gunzip -c > BUILD/geoip-db/GeoIP.dat
	wget -O - $(GEOIP_ASN_DB) | gunzip -c > BUILD/geoip-db/GeoIPASNum.dat
	wget -O - $(GEOIP_CITY_DB) | gunzip -c > BUILD/geoip-db/GeoLiteCity.dat

	cp megatron.spec SPECS/

	wget -O SOURCES/megatron.tar.gz $(MEGATRON_DIST) 
	echo "$(MEGATRON_DIST_MD5)  SOURCES/megatron.tar.gz" | md5sum -c
	tar -xf SOURCES/megatron.tar.gz -C BUILD/

	cp -r megatron BUILD/

	# Download log4j 2.17.1
	wget -O log4j_dist/log4j.tar.gz $(LOG4J_DIST)
	echo "$(LOG4J_SHA256SUM)  log4j_dist/log4j.tar.gz" | sha256sum -c
	tar -xf log4j_dist/log4j.tar.gz -C log4j_dist/
	rm BUILD/megatron-java/lib/log4j.jar
	cp log4j_dist/apache-log4j-2.17.1-bin/log4j-1.2-api-2.17.1.jar BUILD/megatron-java/lib/
	cp log4j_dist/apache-log4j-2.17.1-bin/log4j-api-2.17.1.jar BUILD/megatron-java/lib/
	cp log4j_dist/apache-log4j-2.17.1-bin/log4j-core-2.17.1.jar BUILD/megatron-java/lib/

	rpmbuild --define "_topdir `pwd`" -bb SPECS/megatron.spec

	cp RPMS/noarch/* .

clean:
	rm -rf BUILD
	rm -rf BUILDROOT
	rm -rf SOURCES
	rm -rf SPECS
	rm -rf RPMS
	rm -rf SRPMS
	rm -rf log4j_dist
	rm -f *.rpm

