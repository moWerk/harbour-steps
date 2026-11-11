Name:       harbour-steps
Summary:    Steps, a step counter
Version:    0.1.0
Release:    1
License:    GPLv3+
URL:        https://github.com/moWerk/harbour-steps
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
Requires:   nemo-qml-plugin-configuration-qt5
# the daemon that keeps the counter open and logs the days, with its QML module
Requires:   sensorlogd
Requires:   sensorfw-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Steps shows today's step count against a daily goal, the last weeks as a
list, and puts the count with its goal ring into the top menu. The steps are
counted by the phone's sensor hub and logged by sensorlogd; the app only
reads them. Needs a device whose sensorfw has a step counter adaptor.

%if 0%{?_chum}
Title: Steps
Type: desktop-application
DeveloperName: moWerk
Categories:
 - Utility
PackagerName: moWerk
Custom:
  Repo: https://github.com/moWerk/harbour-steps
Icon: https://raw.githubusercontent.com/moWerk/harbour-steps/main/icons/172x172/harbour-steps.png
%endif

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5 VERSION=%{version}
%make_build

%install
%qmake5_install
# top menu item: the settings entry and its QML
install -D -m 644 entries/harbour-steps-topmenu.json %{buildroot}%{_datadir}/jolla-settings/entries/harbour-steps-topmenu.json
install -D -m 644 topmenu/StepsTopMenu.qml %{buildroot}%{_datadir}/%{name}/topmenu/StepsTopMenu.qml
# sensorfw: enable the step counter sensor on hybris devices
install -D -m 644 sensorfw/90-harbour-steps.conf %{buildroot}%{_sysconfdir}/sensorfw/sensord.conf.d/90-harbour-steps.conf
desktop-file-install --delete-original --dir %{buildroot}%{_datadir}/applications %{buildroot}%{_datadir}/applications/*.desktop

%post
# sensorfwd reads its config at start; pick the step counter up now
systemctl try-restart sensorfwd.service >/dev/null 2>&1 || :

%postun
if [ $1 -eq 0 ]; then
    systemctl try-restart sensorfwd.service >/dev/null 2>&1 || :
fi

%files
%defattr(-,root,root,-)
%config %{_sysconfdir}/sensorfw/sensord.conf.d/90-harbour-steps.conf
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/jolla-settings/entries/harbour-steps-topmenu.json
