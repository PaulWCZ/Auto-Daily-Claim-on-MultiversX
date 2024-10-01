# Configuration of variables
WALLET_PEM="Path/to/WalletPEM"
XP_SC="erd1qqqqqqqqqqqqqpgq8pdxqhhnp38qkezf7lcx5qww85zmph708juq48geul"
PROXY="https://gateway.multiversx.com"
CHAIN="1"

claimXP() {
    # Execute the transaction and capture the output
    output=$(mxpy --verbose contract call ${XP_SC} --recall-nonce \
        --pem=${WALLET_PEM} \
        --gas-limit=5000000 \
        --proxy=${PROXY} --chain=${CHAIN} \
        --function="claim" \
        --send)

    echo "$output"

    # Extract the transaction hash from the output
    txHash=$(echo "$output" | perl -nle 'print $1 if /emittedTransactionHash": "([^"]+)/')
    echo "Transaction Hash: $txHash"

    # Immediately check the transaction status
    checkTransactionStatus "$txHash"
}

checkTransactionStatus() {
    local txHash=$1

    echo "Checking transaction status..."
    response=$(curl -s "${PROXY}/transaction/${txHash}/process-status")
    status=$(echo "$response" | jq -r '.data.status')
    echo "Current status: $status - $response"
}

# Call the function
claimXP
