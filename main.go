package main

import (
	"bytes"
	"fmt"
	"net/http"
)

func main() {
	blockChainEndpoint := "https://polygon-rpc.com/"

	bodyGetBlockNumber := []byte(`{
		"jsonrpc": "2.0",
		"method": "eth_blockNumber",
 		"id": 2
	}`)

	rGetBlockNumber, err := http.NewRequest("POST", blockChainEndpoint, bytes.NewBuffer(bodyGetBlockNumber))
	if err != nil {
		panic(err)
	}
	rGetBlockNumber.Header.Add("Content-Type", "application/json")

	client := &http.Client{}
	resGetBlockNumber, err := client.Do(rGetBlockNumber)
	if err != nil {
		panic(err)
	}

	defer resGetBlockNumber.Body.Close()

	fmt.Println(resGetBlockNumber.Body)



	bodyGetBlockByNumber := []byte(`{
		"jsonrpc": "2.0",
 		"method": "eth_getBlockByNumber",
		"params": [
			"0x134e82a",
			true
 		],
		"id": 2
	}`)

	rGetBlockByNumber, err := http.NewRequest("POST", blockChainEndpoint, bytes.NewBuffer(bodyGetBlockByNumber))
	if err != nil {
		panic(err)
	}
	rGetBlockByNumber.Header.Add("Content-Type", "application/json")

	resGetBlockByNumber, err := client.Do(rGetBlockNumber)
	if err != nil {
		panic(err)
	}

	defer resGetBlockByNumber.Body.Close()

	fmt.Println(resGetBlockByNumber.Body)



}
