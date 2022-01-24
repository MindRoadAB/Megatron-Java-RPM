Name:           megatron
Version:        1.1.0
Release:        1%{?dist}
Summary:        Megatron - A System for Abuse- and Incident Handling
BuildArch:      noarch

License:        MIT
Source0:        %{name}-%{version}.tar.gz

Requires:       jre
Requires(pre): shadow-utils

%description
Megatron is a tool implemented by CERT-SE which collects and 
analyses log files with bad machines, e.g. from Shadowserver.
Apart from abuse mail handling, Megatron can be used to collect 
statistics, convert log files, and do log file analysis during 
incident handling.

%pre
getent group megatron >/dev/null || groupadd -r megatron
getent passwd u_megatron >/dev/null || \
    useradd -m -r -g megatron -s /bin/bash -c "megatron-java" u_megatron
exit 0

%install
mkdir -p %{buildroot}/usr/local/megatron/lib
mkdir -p %{buildroot}/etc/megatron
mkdir -p %{buildroot}/var/megatron
mkdir -p %{buildroot}/var/megatron/log
mkdir -p %{buildroot}/var/megatron/slurp
mkdir -p %{buildroot}/var/megatron/tmp

cp -r megatron/conf/* %{buildroot}/etc/megatron
cp -r geoip-db %{buildroot}/etc/megatron/
cp -r megatron-java/conf/hibernate-mapping %{buildroot}/etc/megatron
cp -r megatron-java/lib/* %{buildroot}/usr/local/megatron/lib
cp megatron-java/dist/sitic-megatron.jar %{buildroot}/usr/local/megatron/lib

mkdir %{buildroot}/bin
cp megatron/megatron.sh %{buildroot}/bin/megatron.sh
ln -s -f megatron.sh %{buildroot}/bin/megatron

%post

%clean
rm -rf $RPM_BUILD_ROOT

%files
%attr(-, u_megatron, megatron) /usr/local/megatron/lib
%attr(-, u_megatron, megatron) /etc/megatron
%attr(-, u_megatron, megatron) /var/megatron
%attr(0755, u_megatron, megatron) /bin/megatron.sh
%attr(0755, u_megatron, megatron) /bin/megatron
