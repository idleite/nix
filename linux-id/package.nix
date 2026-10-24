
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "linux-id";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "matejsmycka";
    repo = "linux-id";
    rev = "v${version}";
    hash = "sha256-zDlZrQLPi3Y/ntoAGCTyMUJ2j/Zzm0gax8y2MjyIGSk="; # Replace with the verified source hash
  };

  vendorHash = "sha256-G+MNVGrTAiWhJ4XQa5dQ0ChhHTSvO5VMQ/Cy5CWP7tk="; # Replace with the verified Go dependency hash

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  meta = {
    description = "TPM-backed FIDO authenticator for Linux";
    homepage = "https://github.com/matejsmycka/linux-id";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "linux-id";
  };
}
