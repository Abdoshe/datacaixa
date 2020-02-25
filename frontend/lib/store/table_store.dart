import 'package:datacaixa/models/table.dart';
import 'package:datacaixa/repository/tables_repository.dart';
import 'package:mobx/mobx.dart';

part 'table_store.g.dart';

class TableStore = _TableStore with _$TableStore;

abstract class _TableStore with Store {
  TablesRepository repository = TablesRepository();
  @observable
  List<Table> tables = [];

  TableStatus status(index) =>
      tables[index].status == 'Ocupada' ?
      TableStatus.Busy : TableStatus.Idle;

  table(index) => tables[index];

  @action
  Future<List<Table>> getTables() async => tables = await repository.loadTables();
}