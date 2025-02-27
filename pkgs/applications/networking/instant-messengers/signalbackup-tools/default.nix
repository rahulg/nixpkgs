{ lib, stdenv, fetchFromGitHub, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20220825";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-dqP30or4UvtnzUW6r0FqQxt1S6Y61Q1CljpAFGq2gSM=";
  };

  postPatch = ''
    patchShebangs BUILDSCRIPT_MULTIPROC.bash44
  '';

  buildInputs = [ openssl sqlite ];

  # Manually define `CXXFLAGS` and `LDFLAGS` on Darwin since the build scripts includes flags
  # that don't work on Darwin.
  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString stdenv.isDarwin ''
    export CXXFLAGS="-Wall -Wextra -Wshadow -Wold-style-cast -Woverloaded-virtual -pedantic -O3"
    export LDFLAGS="-Wall -Wextra -O3"
  '' + ''
    ./BUILDSCRIPT_MULTIPROC.bash44
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
