##############################################################
# This module allows the creation of a Key Vault Secret
##############################################################

output "keyvault_secret_attributes" {
  description = "The properties of a keyvault secret"
  /*Forced to use data block and resolve output of secrets into an array
  as a workaround to an arm provider bug that will not allow updating app
  service settings with a keyvault version in a more direct way.*/
  value = [for i in range(length(azurerm_key_vault_secret.secret.*.id)) : data.azurerm_key_vault_secret.secrets[i]]
}
