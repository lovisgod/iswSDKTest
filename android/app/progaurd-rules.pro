# ISW classes
    -keep public class com.interswitchng.iswmobilesdk.IswMobileSdk {
      public protected *;
    }

    -keep public interface com.interswitchng.iswmobilesdk.IswMobileSdk$IswPaymentCallback {*;}

    -keep public class com.interswitchng.iswmobilesdk.shared.models.core.** {
        public protected *;
        !transient <fields>;
    }
    -keep public class com.interswitchng.iswmobilesdk.shared.models.payment.** {
        public protected *;
        !transient <field