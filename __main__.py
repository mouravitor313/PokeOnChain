from utils.conected import INFURA_URL, web3
import json
from web3 import Web3

# variables
with open("account.txt", "r") as account:
  account_address = account.readline().strip()
  private_key = account.readline().strip()

with open("utils/pokedex_abi.json", "r") as file:
  pokedex_abi = json.load(file)

with open("utils/pokecoin_abi.json", "r") as file2:
  pokecoin_abi = json.load(file2)

pokedex_address = '0xe6b211733cff82a3a421a5d66fb73191f390c524'
pokedex_contract = web3.eth.contract(address=Web3.to_checksum_address(pokedex_address), abi=pokedex_abi)
pokecoin_address = '0x9569C596E84Dd1983C8164c989664cDb49c42c2B'
pokecoin_contract = web3.eth.contract(address=pokecoin_address, abi=pokecoin_abi)
gas_limit = 100000

# interaction with function
raw_tx = {
  'nonce': web3.eth.get_transaction_count(account_address),
  'gasPrice': web3.eth.gas_price,
  'gas': gas_limit,
  'to': Web3.to_checksum_address(pokedex_address),
  'value': 0,
  'data': pokecoin_contract.functions.approve(Web3.to_checksum_address(pokedex_address), 100).build_transaction({
  'from': account_address})['data']
}

signed_tx = web3.eth.account.signTransaction(raw_tx, private_key)
tx_hash = web3.eth.sendRawTransaction(signed_tx.rawTransaction)
print(tx_hash.hex())




'''
x_hash = contract.functions.setMessage('oiii')
print(tx_hash)
print(contract.functions.getMessage().call())
'''
