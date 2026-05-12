abstract class Failure {
  final String message;
  const Failure(this.message);
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class DataFailure extends Failure {
  const DataFailure(super.message);
}

class RouteFailure extends Failure {
  const RouteFailure(super.message);
}
