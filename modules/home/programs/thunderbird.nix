{ ... }:

{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        "datareporting.healthreport.uploadEnabled" = false;
        "mail.shell.checkDefaultClient" = false;
        "app.donation.eoy.version.viewed" = 999;

        "mail.serverDefaultStoreContractID" = "@mozilla.org/msgstore/maildirstore;1";
      };
    };
  };
}
