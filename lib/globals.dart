const onlineUrl = 'api.schoolroutes.org';
const local = 'localhost/api.schoolroutes.org';

// ignore: dead_code, unnecessary_string_interpolations
const String serverUrl = '${true ? onlineUrl : local}';

const timeout = Duration(minutes: 3);

late String token;

double height = 0.0;
double width = 0.0;
