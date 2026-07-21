using ACS.SPiiPlusNET;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy
            .WithOrigins(
                "http://127.0.0.1:5173",
                "http://localhost:5173",
                "http://47.122.124.86",
                "https://47.122.124.86"
            )
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});
builder.Services.AddSingleton<AcsConnectionService>();

var app = builder.Build();

app.Use(async (context, next) =>
{
    context.Response.Headers["Access-Control-Allow-Private-Network"] = "true";
    await next();
});
app.UseCors();

app.MapGet("/", () => Results.Ok(new { service = "ACS Bridge", status = "running" }));
app.MapGet("/api/acs/status", (AcsConnectionService acs) => Results.Ok(acs.GetStatus()));
app.MapPost("/api/acs/connect", (AcsConnectRequest request, AcsConnectionService acs) =>
{
    var result = acs.Connect(request.Mode, request.Ip, request.Port);
    return Results.Json(result, statusCode: result.Connected ? StatusCodes.Status200OK : StatusCodes.Status500InternalServerError);
});
app.MapPost("/api/acs/disconnect", (AcsConnectionService acs) => Results.Ok(acs.Disconnect()));
app.MapPost("/api/acs/axis/{axis:int}/enable-toggle", (int axis, AcsConnectionService acs) =>
{
    var result = acs.ToggleAxisEnable(axis);
    return Results.Json(result, statusCode: result.Success ? StatusCodes.Status200OK : StatusCodes.Status400BadRequest);
});

app.Run("http://127.0.0.1:5055");

public sealed record AcsConnectRequest(int Mode = 0, string Ip = "10.0.0.100", int Port = 701);

public sealed record AcsStatusResponse(bool Connected, string Mode, string Message);

public sealed record AxisEnableResponse(bool Success, bool Connected, int Axis, bool Enabled, string Message);

public sealed class AcsConnectionService
{
    private readonly object _lock = new();
    private Api? _acs;
    private bool _isConnected;
    private string _mode = "未连接";

    public AcsStatusResponse GetStatus()
    {
        lock (_lock)
        {
            return new AcsStatusResponse(_isConnected, _mode, _isConnected ? "ACS 控制器已连接" : "ACS 控制器未连接");
        }
    }

    public AcsStatusResponse Connect(int mode = 0, string ip = "10.0.0.100", int port = 701)
    {
        lock (_lock)
        {
            if (_isConnected)
            {
                return new AcsStatusResponse(true, _mode, "ACS 控制器已连接");
            }

            _acs = new Api();

            try
            {
                if (mode == 0)
                {
                    _acs.OpenCommSimulator();
                    _mode = "仿真";
                }
                else
                {
                    _acs.OpenCommEthernetTCP(ip, port);
                    _mode = $"TCP {ip}:{port}";
                }

                _isConnected = true;
                return new AcsStatusResponse(true, _mode, "ACS 控制器连接成功");
            }
            catch (Exception ex)
            {
                _isConnected = false;
                _mode = "未连接";
                _acs = null;
                return new AcsStatusResponse(false, _mode, $"ACS 连接失败: {ex.Message}");
            }
        }
    }

    public AcsStatusResponse Disconnect()
    {
        lock (_lock)
        {
            try
            {
                _acs?.CloseComm();
            }
            catch
            {
            }

            _acs = null;
            _isConnected = false;
            _mode = "未连接";

            return new AcsStatusResponse(false, _mode, "ACS 控制器已断开");
        }
    }

    public AxisEnableResponse ToggleAxisEnable(int axis)
    {
        lock (_lock)
        {
            if (!_isConnected || _acs is null)
            {
                return new AxisEnableResponse(false, false, axis, false, "ACS 控制器未连接，无法切换轴使能");
            }

            try
            {
                var targetAxis = (Axis)axis;
                var enabled = IsAxisEnabled(targetAxis);

                if (enabled)
                {
                    _acs.Disable(targetAxis);
                    return new AxisEnableResponse(true, true, axis, false, $"{axis} 号轴已断开使能");
                }

                _acs.Enable(targetAxis);
                return new AxisEnableResponse(true, true, axis, true, $"{axis} 号轴已使能");
            }
            catch (Exception ex)
            {
                return new AxisEnableResponse(false, true, axis, false, $"ACS 轴使能切换失败: {ex.Message}");
            }
        }
    }

    private bool IsAxisEnabled(Axis axis)
    {
        if (_acs is null)
        {
            return false;
        }

        var state = _acs.GetMotorState(axis);
        return (state & MotorStates.ACSC_MST_ENABLE) != 0;
    }
}
