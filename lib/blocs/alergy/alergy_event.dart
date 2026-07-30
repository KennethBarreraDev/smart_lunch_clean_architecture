abstract class AlergyEvent {
  const AlergyEvent();
}

class LoadAlergies extends AlergyEvent {
  const LoadAlergies();
}

class RefreshAlergies extends AlergyEvent {
  const RefreshAlergies();
}
