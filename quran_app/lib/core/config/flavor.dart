/// Uygulamanın çalıştığı ortam (TK-07).
///
/// `dev` sahte servislerle, `prod` gerçek servislerle çalışır.
enum Flavor {
  dev,
  prod;

  bool get isDev => this == Flavor.dev;
}
