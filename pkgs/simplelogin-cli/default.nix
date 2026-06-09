{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "simplelogin-cli";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mexcool";
    repo = "simplelogin-cli";
    tag = "v${finalAttrs.version}";
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

  nativeBuildInputs = [
    installShellFiles
  ];

  preBuild = ''
    go run ./cmd/gen-man
  '';

  postInstall = ''
    installManPage man/*.[1-9]
    rm $out/bin/gen-man
    ln -s sl $out/bin/simplelogin-cli
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SimpleLogin cli to manage email aliases from the terminal.";
    homepage = "https://github.com/mexcool/simplelogin-cli";
    changelog = "https://github.com/mexcool/simplelogin-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afh ];
    mainProgram = "sl";
  };
})
