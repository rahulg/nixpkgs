{ lib, stdenv, fetchzip, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "asciidoctorj";
  version = "2.5.5";

  src = fetchzip {
    url = "mirror://maven/org/asciidoctor/${pname}/${version}/${pname}-${version}-bin.zip";
    sha256 = "sha256-0MWZKT4TkgNEJPP0HRc316P2AFeZ2gh+mu30X0y3Otc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/asciidoctorj.bat
    cp -r . $out
    wrapProgram $out/bin/asciidoctorj \
      --prefix JAVA_HOME : ${jdk}
  '';

  meta = with lib; {
    description = "Official library for running Asciidoctor on the JVM";
    longDescription = ''
      AsciidoctorJ is the official library for running Asciidoctor on the JVM.
      Using AsciidoctorJ, you can convert AsciiDoc content or analyze the
      structure of a parsed AsciiDoc document from Java and other JVM
      languages.
    '';
    homepage = "https://asciidoctor.org/docs/asciidoctorj/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
