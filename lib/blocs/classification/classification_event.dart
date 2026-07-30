abstract class ClassificationEvent {
  const ClassificationEvent();
}

class LoadClassifications extends ClassificationEvent {
  const LoadClassifications();
}

class RefreshClassifications extends ClassificationEvent {
  const RefreshClassifications();
}
