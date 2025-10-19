import 'package:doctor_on_duty/domain/models/case.dart';

import 'package:doctor_on_duty/utils/repositories.dart';

class CasesRepository extends CrudRepository<Caze> {}

final casesRepository = CasesRepository();
