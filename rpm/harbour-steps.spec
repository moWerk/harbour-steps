Name:       harbour-steps
Summary:    Steps, a step counter
Version:    0.1.0
Release:    1
License:    GPLv3+
URL:        https://github.com/moWerk/steps
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
Requires:   nemo-qml-plugin-configuration-qt5
# the daemon that keeps the counter open and logs the days, with its QML module
Requires:   sensorlogd
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
  Repo: https://github.com/moWerk/steps
Icon: https://raw.githubusercontent.com/moWerk/steps/main/icons/172x172/harbour-steps.png
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
desktop-file-install --delete-original --dir %{buildroot}%{_datadir}/applications %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/jolla-settings/entries/harbour-steps-topmenu.json
