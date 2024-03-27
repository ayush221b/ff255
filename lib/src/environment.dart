class Environment {
  final Map<String, dynamic> values = {};
  Environment? enclosing; // For supporting nested scopes (optional)

  Environment([this.enclosing]);

  void define(String name, dynamic value) {
    values[name] = value;
  }

  dynamic get(String tokenName) {
    if (values.containsKey(tokenName)) {
      return values[tokenName];
    }

    // If variable not found, check enclosing scope (optional)
    if (enclosing != null) {
      return enclosing!.get(tokenName);
    }

    throw Exception('Undefined variable "$tokenName".');
  }

  void assign(String tokenName, dynamic value) {
    values[tokenName] = value; // Always assign or update the value

    // If variable not found in the current scope,
    // check the enclosing scope
    if (enclosing != null && !values.containsKey(tokenName)) {
      enclosing!.assign(tokenName, value);
    } else if (!values.containsKey(tokenName)) {
      // No enclosing scope check
      throw Exception('Undefined variable "$tokenName".');
    }
  }
}
