sh build_multicaller.sh > /dev/null 2>&1
MULTICALLER_INITCODE=$(cat multicaller/initcode.txt)
export MULTICALLER_INITCODE

sh build_multicaller_with_sender.sh > /dev/null 2>&1
MULTICALLER_WITH_SENDER_INITCODE=$(cat multicaller_with_sender/initcode.txt)
export MULTICALLER_WITH_SENDER_INITCODE

sh build_multicaller_with_signer.sh > /dev/null 2>&1
MULTICALLER_WITH_SIGNER_INITCODE=$(cat multicaller_with_signer/initcode.txt)
export MULTICALLER_WITH_SIGNER_INITCODE

npx sphinx propose script/Deploy.s.sol --networks polygon_amoy arbitrum_sepolia base_sepolia avalanche_fuji zora_sepolia
