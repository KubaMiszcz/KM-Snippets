@Output()notify : EventEmitter < asdasd > = new EventEmitter < asdasd > ();

passValueFromEvent(value : asdasd) {
    this
        .notify
        .emit(value);
}

@Output()notify : EventEmitter < number > = new EventEmitter < number > ();

passValueFromEvent(value : number) {
    this
        .notify
        .emit(value);
}
passValueFromEvent(value : type) {
    this
        .notify
        .emit(value);
}
