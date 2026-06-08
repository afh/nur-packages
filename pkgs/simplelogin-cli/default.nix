{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "simplelogin-cli";
  version = "0.4.0";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "mexcool";
    repo = "simplelogin-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Gs3hOoRBzDXXbRgs0Pykobxlzt1qbFzsIjQpcIoo6iE=";
  };

  vendorHash = "sha256-6skLoiAeVRJQgmcB0v/OXxrMBMJBVKsiOsXDIYJU+Lg=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  preBuild = ''
    go run ./cmd/gen-man
  '';

  postInstall = ''
    installManPage man/*.[1-9]
  '';

  meta = {
    description = "SimpleLogin cli to manage email aliases from the terminal.";
    homepage = "https://github.com/mexcool/simplelogin-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afh ];
    mainProgram = "sl";
  };
})
