abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en": en,
    "de-ch": deCh,
    "ro": ro,
    "nl-nl": nlNl,
  };
}
/*----------------------------- English -----------------------------*/
final Map<String, String> en = {

  /* module: termsAndConditions */
  "terms-conditions":                             "Terms and Conditions",
  "at-least-16":                                  "I am at least 16 years old.",
  "have-signed-consent-form":                     "I have signed a consent form.",
  "read-agree-privacy-policy":                    "I have read and agree with the Privacy Policy of the GEIGER Toolbox.",
  "your-company-does":                            "Your company does...",
  "only-consume-digital-products":                "only consume digital products",
  "sell-digital-products-no-develop":             "sell digital products but not develop them",
  "develop-and-sell-digital-products":            "develop and sell digital products itself",
  "info-accept-terms":                            "In order to use the toolbox all terms above have to be accepted",
  "continue-btn-label":                           "Continue",

  /* module: settings */
  "title-settings":                               "Settings",
  "profile":                                      "Profile",
  "data-protection":                              "Data Protection",
  "data":                                         "Data",

  /* module: settings
     widgets: data_protection_view */
  "warning":                                      "Warning",
  "data-access-warning-text":                     "Are you sure you want to disable Data Access and Processing? The setting will be applied after you restart the app.",
  "data-access-title":                            "Data Access",
  "data-access-success-text":                     "Consent successfully updated.",
  "data-access-failed-text":                      "Consent fail to update.",
  "ok":                                           "ok",
  "cancel":                                       "cancel",
  "data-access-processing-title":                 "Data Access and Processing",
  "data-access-processing-desc":                  "Allow the toolbox to calculate your risk score and receive protection recommendations.",
  "data-sharing-title":                           "Data Sharing",
  "do-not-share":                                 "Do not share",
  "do-not-share-desc":                            "Data will remain on this single device only.",
  "do-not-share-warning-dialog":                  "Are you sure you want to stop your data from be replicated. The setting will be applied after you restart the app.",
  "replicate-between-your-devices":               "Replicate securely between your devices.",
  "replicate-between-your-devices-desc":          "All your data will be available on all your devices.",
  "replication":                                  "Replication",
  "replication-success-text":                     "Your data was successfully replicated.",
  "replication-failed-text":                      "Your data replication failed.",
  "share-data-with-cloud":                        "Share data with GEIGER cloud.",
  "share-data-with-cloud-desc":                   "Your tools’ data will be used to improve GEIGER over time.",
  "tools-may-process-data":                       "Tools may process  your data",
  "tools-may-process-data-desc":                  "This setting enables or disables the tools’ ability to process your data and offer personalised services. When enabled, you can disable the setting for each tool.",
  "tools":                                        "Tools",
  "incident-reporting":                           "Incident reporting",
  "incident-reporting-desc":                      "When experiencing an incident, you will have the ability to submit an incident report to your chosen cybersecurity agency (CERT). You will be asked each time whether you want to report the incident.",
  "alert":                                        "Alert",
  "info-alert-needs-permission":                  "Toolbox needs you to grant permission for data access and processing.",
  "navigate-to-scan-screen":                      "Navigate to Scan Screen",

  /* module: settings
     widgets: data_view */
  "allow-data-access-process":                    "Allow Data Access and Process!",
  "export":                                       "Export",

  /* module: settings
     widgets: profile_view */
  "user-name-label":                              "User Name",
  "user-name-hint":                               "Enter User name",
  "user-name-warning":                            "Please Enter your Name", // controller: profile_controller
  "device-name-label":                            "Name of this Device",
  "device-name-hint":                             "Enter Device name",
  "device-name-warning":                          "Please Enter your Device Name", // controller: profile_controller
  "company-owner":                                 "I’m a company owner",
  "company-owner-desc":                           "As an owner you can compare your company’s geiger score with others.",
  "language":                                     "Language",
  "country":                                      "Country",
  "select-your-country":                          "Select Your Country",
  "competent-cert":                               "Competent CERT",
  "select-competent-cert":                        "Select Competent CERT",
  "profession-association":                       "Profession Association",
  "select-profession-association":                "Select Profession Association",
  "success":                                      "Success",
  "updated-successfully":                         "Updated Successfully.",
  "message-alert":                                "Message Alert",
  "update-failed-contact-developer":              "Update Failed! Contact the Developer",
  "update":                                       "Update",

  //TODO: Translation to German
  /* module: tools
     widgets: tools_card
   */
  "install":                                      "Install",

  /* module: security_defenders */
  "select-country":                               "Select Country",
  "association":                                  "Association",
  "search-region":                                "Search region",


  /* module: home */
  "geiger-toolbox": "Geiger Toolbox",
  "no-data-found": "NO DATA FOUND",
};
/*----------------------------- German -----------------------------*/
final Map<String, String> deCh = {

  /* module: termsAndConditions */
  "terms-conditions":                             "Allgemeine Geschäftsbedingungen",
  "at-least-16":                                  "Ich bin mindestens 16 Jahre alt.",
  "have-signed-consent-form":                     "Ich habe eine Einverständniserklärung unterschrieben.",
  "read-agree-privacy-policy":                    "Ich habe die Datenschutzbestimmungen der GEIGER-Toolbox gelesen und bin damit einverstanden.",
  "your-company-does":                            "Ihr Unternehmen...",
  "only-consume-digital-products":                "nutzt nur digitale Produkte",
  "sell-digital-products-no-develop":             "verkauft digital Produkte, aber entwickelt selbst keine",
  "develop-and-sell-digital-products":            "entwickelt und verkauft digitale Produkte",
  "info-accept-terms":                            "Für die Nutzung der Toolbox, müssen alle oben genannten Bedingungen akzeptiert werden",
  "continue-btn-label":                           "Weiter",


  /* module: settings */
  "title-settings":                               "Einstellungen",
  "profile":                                      "Profil",
  "data-protection":                              "Datenschutz",
  "data":                                         "Daten",

  /* module: settings
     widgets: data_protection_view */
  "warning":                                      "Warnung",
  "data-access-warning-text":                     "Sind Sie sicher, dass Sie den Datenzugriff und die Datenverarbeitung deaktivieren möchten? Die Einstellung wird nach dem Neustart der App übernommen.",
  "data-access-title":                            "Datenzugriff",
  "data-access-success-text":                     "Genehmigungen erfoglreich aktualisiert.",
  "data-access-failed-text":                      "Genehmigungen konnten nicht aktualisiert werden.",
  "ok":                                           "Okay",
  "cancel":                                       "Abbrechen",
  "data-access-processing-title":                 "Datenzugriff und -verarbeitung",
  "data-access-processing-desc":                  "Erlauben Sie der Toolbox, Ihren Risiko-Score zu berechnen, sowie Sicherheitsempfehlungen zu erhalten.",
  "data-sharing-title":                           "Datenfreigabe",
  "do-not-share":                                 "nicht freigeben",
  "do-not-share-desc":                            "Die Daten verbleiben nur auf diesem Gerät.",
  "do-not-share-warning-dialog":                  "Sind Sie sicher, dass Sie die Abbildung Ihrer Daten unterbinden möchten. Die Einstellung wird nach dem Neustart der App übernommen.",
  "replicate-between-your-devices":               "Sichere Abbildung zwischen Ihren Geräten.",
  "replicate-between-your-devices-desc":          "Die Daten sind auf allen Geräten verfügbar.",
  "replication":                                  "Abbildung",
  "replication-success-text":                     "Die Daten wurden erfolgreich abgebildet.",
  "replication-failed-text":                      "Die Abbildung der Daten ist fehlgeschlagen.",
  "share-data-with-cloud":                        "Daten mit der GEIGER-Cloud teilen.",
  "share-data-with-cloud-desc":                   "Ihre Tools Daten werden verwendet, um GEIGER im Laufe der Zeit zu verbessern.",
  "tools-may-process-data":                       "Tools können Ihre Daten verarbeiten",
  "tools-may-process-data-desc":                  "Diese Einstellung aktiviert oder deaktiviert die Berechtigung der Tools, Ihre Daten zu verarbeiten und personalisierte Dienste bereitzustellen. Wenn sie aktiviert ist, kann jedes Tool individuell deaktiviert werden.",
  "tools":                                        "Werkzeuge",
  "incident-reporting":                           "Vorfall melden",
  "incident-reporting-desc":                      "Bei einem Vorfall haben Sie die Möglichkeit, eine Vorfallbericht an die von Ihnen gewählte Cybersicherheitsagentur (CERT) zu senden. Sie werden jedes Mal gefragt, ob Sie den Vorfall melden möchten.",
  "alert":                                        "Warnung",
  "info-alert-needs-permission":                  "Die Toolbox benötigt Ihre Zustimmung für den Datenzugriff und die Datenverarbeitung.",
  "navigate-to-scan-screen":                      "Zum Scan-Bildschirm",

  /* module: settings
     widgets: data_view */
  "allow-data-access-process":                    "Datenzugriff und Verarbeitung zulassen!",
  "export":                                       "Exportieren",

  /* module: settings
     widgets: profile_view */
  "user-name-label":                              "Nutzername",
  "user-name-hint":                               "Nutzername eingeben",
  "user-name-warning":                            "Bitte Nutzername eingeben",
  "device-name-label":                            "Name dieses Geräts",
  "device-name-hint":                             "Gerätename eingeben",
  "device-name-warning":                          "Bitte Gerätename eingeben",
  "company-owner":                                "Ich bin Inhaber eines Unternehmens",
  "company-owner-desc":                           "Als Eigentümer können Sie den Geiger-Score Ihres Unternehmens mit andereren Unternehmen vergleichen.",
  "language":                                     "Sprache",
  "country":                                      "Land",
  "select-your-country":                          "Land auswählen",
  "competent-cert":                               "Zuständiges CERT",
  "select-competent-cert":                        "Zuständiges CERT auswählen",
  "profession-association":                       "Berufsverband",
  "select-profession-association":                "Berufsverband auswählen",
  "success":                                      "Erfolgreich",
  "updated-successfully":                         "erfolgreich aktualisiert.",
  "message-alert":                                "Warnmeldung",
  "update-failed-contact-developer":              "Aktualisierung fehlgeschlagen! Kontaktieren Sie den Entwickler.",
  "update":                                       "Aktualisieren",


  /* module: home */
  "geiger-toolbox": "Geiger Toolbox",
  "no-data-found": "KEINE DATEN GEFUNDEN",

};

/*----------------------------- Romanian -----------------------------*/
final Map<String, String> ro = {

  /*"geiger-toolbox": "Geiger Toolbox",
  "update-button-label": "Actualizați",
  "title-settings": "setări",
  "profile": "Profil",
  "data-protection": "Protejarea datelor",
  "data": "Date"*/
};

/*----------------------------- Dutch -----------------------------*/
final Map<String, String> nlNl = {


  /*"geiger-toolbox": "Geiger-gereedschapskist",
  "update-button-label": "Bijwerken",
  "title-settings": "instellingen",
  "profile": "Profiel",
  "data-protection": "Gegevensbescherming",
  "data": "Gegevens"*/
};
