# zebra-printer-capacitor-plugin

Capacitor plugin for the Zebra printer SDK

## Install

```bash
npm install zebra-printer-capacitor-plugin
npx cap sync
```

## API

<docgen-index>

* [`setupConnection(...)`](#setupconnection)
* [`discover(...)`](#discover)
* [`health()`](#health)
* [`print(...)`](#print)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### setupConnection(...)

```typescript
setupConnection(options: { ip: string; port: number; }) => any
```

| Param         | Type                                       |
| ------------- | ------------------------------------------ |
| **`options`** | <code>{ ip: string; port: number; }</code> |

**Returns:** <code>any</code>

--------------------


### discover(...)

```typescript
discover(options: { hops: number; waitForResponsesTimeout: number; }) => any
```

| Param         | Type                                                            |
| ------------- | --------------------------------------------------------------- |
| **`options`** | <code>{ hops: number; waitForResponsesTimeout: number; }</code> |

**Returns:** <code>any</code>

--------------------


### health()

```typescript
health() => any
```

**Returns:** <code>any</code>

--------------------


### print(...)

```typescript
print(options: { data: string; }) => any
```

| Param         | Type                           |
| ------------- | ------------------------------ |
| **`options`** | <code>{ data: string; }</code> |

**Returns:** <code>any</code>

--------------------

</docgen-api>
