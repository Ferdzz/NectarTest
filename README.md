# iOS Profeciency test

Build an application that resolves following user stories:

## User stories

- As a user I would like to see a list of hives
- As a user I would like to delete a hive
- As a user I would like to access my hives list while offline
- As a user I would like to be able to delete my hives while offline

## Test rules

- You can use external libraries such a cocoapods
- All codes must be commited within 24 hours of receving the test link

## Installation

Clone the following repository: git@bitbucket.org:exerepo/iosdevtest.git

## Api access

Base URL: https://60a3cfee7c6e8b0017e27f64.mockapi.io/api/v1/

| METHOD | PATH       |
| ------ | ---------- |
| GET    | /hives     |
| GET    | /hives/:id |
| POST   | /hives     |
| PUT    | /hives/:id |
| DELETE | /hives/:id |

### Model

```sh
{
    "id": "1",
    "createdAt": "2021-05-18T04:04:51.927Z",
    "name": "Common Eider",
    "image": "http://placeimg.com/640/480/nature"
}
```
