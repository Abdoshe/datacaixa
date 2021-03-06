package repository

import (
	"fmt"
	"github.com/braulio94/datacaixa/backend/database"
	"github.com/braulio94/datacaixa/backend/model"
)


func (r *DatabaseRepository) LoginUser(user model.User) bool {
	sucess := -1
	formattedQuery := fmt.Sprintf(database.LoginUser, user.UserId, user.Password)
	_ = database.Database.QueryRow(formattedQuery).Scan(&sucess)
	if sucess == 1 {
		return true
	}
	return false
}

func (r *DatabaseRepository) GetUser(userId int) (user model.User) {
	formattedQuery := fmt.Sprintf(database.SelectUser, userId)
	_ = database.Database.QueryRow(formattedQuery).Scan(
		&user.HotelId,
		&user.UserId,
		&user.UserName,
		&user.Name,
		&user.Email,
	)
	return user
}

func (r *DatabaseRepository) GetUsers() (users []model.User) {
	rows, _ := database.Query(database.SelectUsers)
	var user model.User
	for rows.Next() {
		_ = rows.Scan(
			&user.HotelId,
			&user.UserId,
			&user.UserName,
			&user.Name,
			&user.Email,
		)
		users = append(users, user)
	}
	return users
}
