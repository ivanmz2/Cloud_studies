## Lab 01

### 1. Install Go 
Run `go version` in your terminal. You should see the Go version you have on your system:
```bash
go version go1.19 darwin/amd64
```

---

### 2. Install Python
Run `python --version` in your terminal. You should see the Python version you have on your system:
```bash
Python 3.10.6
```

---

### 3. Write a Go program that prints out your name and age
Declare a variable for your name and another one for your age. Then use `fmt.Printf` function to print them out.


---

### 4. Write a Python program that prints out your name and age
Declare a variable for your name and another one for your age. Then use Python's f-string to print them out.


---

### 5. Show different ways of creating a variable in Go
Create a `string` variable named `name`.


---

### 6. Run the following program and explain the output
```go
package main

import "fmt"

func main() {
	var name string = "Alice"

	fmt.Println(name)
	fmt.Println(&name)
}
```


---

### 7. Create a function in Go
Create a function that takes two numbers of type `int` and returns the result. Then print out the result.


---

### 8. Create a function in Python
Create a function that takes two numbers of type `int` and returns the result. Then print out the result.


---

### 9. Run the following programs and explain the results
Program 1:
```go
package main

import "fmt"

func main() {
	number1, number2 := 10, 5

	doubleNumbers(number1, number2)

	fmt.Printf("number1 is %d and number2 is %d\n", number1, number2)
}

func doubleNumbers(a int, b int) {
	a = a * 2
	b = b * 2
}
```

Program 2:
```go
package main

import "fmt"

func main() {
	number1, number2 := 10, 5

	doubleNumbers(&number1, &number2)

	fmt.Printf("number1 is %d and number2 is %d\n", number1, number2)
}

func doubleNumbers(a *int, b *int) {
	*a = *a * 2
	*b = *b * 2
}
```


---

### 10. Find AWS SDK documentation page
Find the documentation page for both Go and Python SDK for the S3 service.


---

### 11. Create an S3 bucket with Terraform
Name your S3 bucket after your name + some random number. Make sure versioning is enabled for the bucket. Use Terraform [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) for creating an S3 bucket.


---

### 12. Write a Go program to upload objects to S3
Write a program that creates 3 files in the S3 bucket you created in the previous exercise. Here's the map of file names and their contents:
```bash
my_file_1.txt -> This is file 1 from Go
my_file_2.txt -> This is file 2 from Go
my_file_3.txt -> This is file 3 from Go
```

Use `aws-vault` to give your program temporary credentials (this way, you won't need to specify an AWS profile in your code). Use a `map` to map the file names to their contents. Use a `for` loop to upload the files to S3.


---

### 13. Write a Python program to upload objects to S3
Write the same program you wrote in the previous exercise, but this time in Python. Change the file contents to `from Python`. Don't change the file names. Since we enabled versioning on the bucket, you will be able to see both versions (Go and Python). After running the program, head to the S3 console and view all versions.


--- 

### 14. Write a program in Go to delete an object in S3
Delete one of the files you created in a previous exercise (example: `my_file_1.txt`). Use AWS SDK documentation for Go.


---

### 15. Write a program in Python to delete an object in S3
Delete another file you created in a previous exercise (example: `my_file_2.txt`). Use AWS SDK documentation for Python.


---

### 16. Write a Go program that lists objects in an S3 bucket
Write a program that lists objects in the S3 bucket you created before. Only list objects with the prefix `my_file`. Then try to list objects with a prefix that doesn't exist (like `random_`). Use AWS SDK documentation for Go.


---

### 17. Write a Python program that lists objects in an S3 bucket
Write a program that lists objects in the S3 bucket you created before. Only list objects with the prefix `my_file`. Then try to list objects with a prefix that doesn't exist (like `random_`). Use AWS SDK documentation for Python.
