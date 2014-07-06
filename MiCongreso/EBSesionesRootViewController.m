//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBSesionesRootViewController.h"

@interface EBSesionesRootViewController ()

@end

@implementation EBSesionesRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Get senado urls
    
    NSString *string = [NSString stringWithFormat:@"%@index.php", kSenadoresBaseURL];
    NSURL *URL = [NSURL URLWithString:string];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            TFHpple *parser = [TFHpple hppleWithHTMLData:data];
            NSString *queryString = @"//div[@id='cuerpo_1']/ul/li";
            NSArray *nodes = [parser searchWithXPathQuery:queryString];
            
            TFHppleElement *ordenDelDia = [nodes objectAtIndex:0];
            TFHppleElement *listaDeAsistencia = [nodes objectAtIndex:2];
            TFHppleElement *votaciones = [nodes objectAtIndex:3];
            
            NSString *ordenString = [[[ordenDelDia firstChild]firstChild]objectForKey:@"href"];
            NSString *listaString = [[[listaDeAsistencia firstChild]firstChild]objectForKey:@"href"];
            NSString *votacionesString = [[[votaciones firstChild]firstChild]objectForKey:@"href"];
            
            senadoOrdenDelDiaURL = [NSURL URLWithString:ordenString];
            senadoAsistenciaURL = [NSURL URLWithString:listaString];
            senadoVotacionesURL = [NSURL URLWithString:votacionesString];
            
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Cámara de Senadores";
        case 1:
            return @"Cámara de Diputados";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Senadores
    if (section==0)
        return 3;
    //Diputados
    else
        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    //Senadores
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Orden del día";
                break;
            case 1:
                cell.textLabel.text = @"Lista de asistencia";
                break;
            case 2:
                cell.textLabel.text = @"Votaciones";
                break;
            default:
                break;
        }
    //Diputados
    }else{
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Orden del día";
                break;
            case 1:
                cell.textLabel.text = @"Sinopsis de dictámenes";
                break;
            case 2:
                cell.textLabel.text = @"Resumen de la sesión";
                break;
            case 3:
                cell.textLabel.text = @"Datos relevantes";
                break;
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
    
    //Senadores
    if (indexPath.section==0) {
        NSURL *theURL;
        
        if (indexPath.row==0)
            theURL = senadoOrdenDelDiaURL;
        else if(indexPath.row==1)
            theURL = senadoAsistenciaURL;
        else
            theURL = senadoVotacionesURL;
        
        EBBrowserViewController *browser = [[EBBrowserViewController alloc]initWithTitle:title andURL:theURL];
        
        [self.navigationController pushViewController:browser animated:YES];

        
        //Diputados
    }else{
        if (indexPath.row==0) {
            
            EBBrowserViewController *browser = [[EBBrowserViewController alloc]initWithTitle:title andURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@orden/hoy.pdf", kDiputadosBaseURL]]];
            
            [self.navigationController pushViewController:browser animated:YES];
        }else if(indexPath.row==1){
            EBBrowserViewController *browser = [[EBBrowserViewController alloc]initWithTitle:title andURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@servicios/datorele/LXII_LEG/Sinopsis_dictamenes_sesion.pdf", kDiputadosBaseURL]]];
            
            [self.navigationController pushViewController:browser animated:YES];
        }else if(indexPath.row==2){
            EBBrowserViewController *browser = [[EBBrowserViewController alloc]initWithTitle:title andURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@servicios/datorele/LXII_LEG/Resumen.pdf", kDiputadosBaseURL]]];
            [self.navigationController pushViewController:browser animated:YES];
        }else if(indexPath.row==3){
            EBBrowserViewController *browser = [[EBBrowserViewController alloc]initWithTitle:title andURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@servicios/datorele/LXII_LEG/datos_relevantes.pdf", kDiputadosBaseURL]]];
            [self.navigationController pushViewController:browser animated:YES];
        }
        
    }
    
}


@end
