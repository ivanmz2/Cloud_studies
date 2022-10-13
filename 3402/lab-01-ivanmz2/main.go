package main

import (
	"context"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/google/uuid"
)

// it's important that the fields are uppercased
// the json library needs them this way
type Product struct {
	Name          string  `json:"name"`
	ID            string  `json:"id"`
	Price         float64 `json:"price"`
	CustomerEmail string  `json:"email"`
}

func main() {
	f, err := os.Open("armani.csv")
	if err != nil {
		log.Fatal(err)
	}

	defer f.Close()

	csvReader := csv.NewReader(f)
	data, err := csvReader.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	// defining a min and max for a fake price
	maxPrice := 1000
	minPrice := 100

	// since we're using aws-vault, there's no need
	// to specify an AWS profile here
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic(err)
	}

	ctx := context.Background()
	sqsClient := sqs.NewFromConfig(cfg)
	sqsURL := "https://sqs.ca-central-1.amazonaws.com/234121525995/purchase"
	emails := []string{"test@test.com", "test2@test.com"}

	for _, record := range data[1:][:] {
		// the uuid library generates a unique identifier
		productID := uuid.NewString()
		productName := record[0]

		// rand.Intn(m) generates a random number between 0 and m
		priceStr := fmt.Sprintf("%d.99", rand.Intn(maxPrice)+minPrice)
		productPrice, err := strconv.ParseFloat(priceStr, 64)
		if err != nil {
			log.Fatal(err)
		}

		product := Product{
			Name:  productName,
			ID:    productID,
			Price: productPrice,

			// choosing an email address in random from
			// the emails variable
			CustomerEmail: emails[rand.Intn(len(emails))],
		}

		// json.Marshal converts the struct to a json format
		productJson, err := json.Marshal(product)
		if err != nil {
			log.Fatal(err)
		}

		_, err = sqsClient.SendMessage(ctx,
			&sqs.SendMessageInput{
				QueueUrl: aws.String(sqsURL),

				// since json.Marshal returns []byte,
				// we need to cast it to string first
				MessageBody: aws.String(string(productJson)),
			},
		)
		if err != nil {
			panic(err)
		}

		fmt.Printf("Order %s was sent\n", product.ID)

		// we're sleeping for 1 second here to
		// be able to track the progress
		time.Sleep(1 * time.Second)
	}
}
