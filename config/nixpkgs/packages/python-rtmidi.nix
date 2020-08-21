{ lib, buildPythonPackage, fetchPypi, isPy27
, pkg-config, alsaLib, libjack2, tox, flake8, alabaster
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hxpnbham3b6m6l1bgmv1bgyiwi85q6gyz1pmnbcs1zl8cvfs89p";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib libjack2 ];
  checkInputs = [
    tox
    flake8
    alabaster
  ];

  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://chrisarndt.de/projects/python-rtmidi/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
