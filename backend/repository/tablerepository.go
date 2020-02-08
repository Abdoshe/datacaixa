package repository

import (
	"fmt"
	"github.com/braulio94/datacaixa/backend/database"
	"github.com/braulio94/datacaixa/backend/model"
)

func (r *DatabaseRepository) GetTable(tableId int) (table model.Table) {
	formattedQuery := fmt.Sprintf(database.SelectTable, tableId)
	_ = database.Database.QueryRow(formattedQuery).Scan(
		&table.HotelId,
		&table.PDVId,
		&table.TableId,
		&table.Number,
		&table.Status,
		&table.BirthdayPerson,
		&table.VIP,
		&table.Honeymoon,
		&table.PVD,
		&table.Seats,
	)
	return table
}

func (r *DatabaseRepository) GetTables() (tables []model.Table) {
	rows, _ := database.Query(database.SelectTables)
	table := model.Table{}
	for rows.Next() {
		_ = rows.Scan(
			&table.HotelId,
			&table.PDVId,
			&table.TableId,
			&table.Number,
			&table.Status,
			&table.BirthdayPerson,
			&table.VIP,
			&table.Honeymoon,
			&table.PVD,
			&table.Seats,
		)
		tables = append(tables, table)
	}
	return tables
}
