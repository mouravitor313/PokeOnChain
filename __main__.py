from utils.conected import INFURA_URL, web3
import json
from web3 import Web3

# variables
with open("utils/abi.json", "r") as f:
  abi = json.load(f)

with open("account.txt", "r") as account:
  account_address = account.readline().strip()
  private_key = account.readline().strip()

pokedex_address = '0xe6b211733cff82a3a421a5d66fb73191f390c524'
contract = web3.eth.contract(address=Web3.to_checksum_address(pokedex_address), abi=abi)

# interaction with function
tx_hash = contract.functions.createPokemon("Charmander", 1).transact({'from': account_address, 'privateKey': private_key})

#events
event_filter = contract.events.PokemonCreated.createFilter(fromBlock='latest')
events = event_filter.get_all_entries()
for event in events:
  print(event)


'''
x_hash = contract.functions.setMessage('oiii')
print(tx_hash)
print(contract.functions.getMessage().call())
'''
